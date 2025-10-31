import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:observable_ish/observable_ish.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;
import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hex/hex.dart';
import 'package:web3dart/credentials.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/locator.dart';


class CryptoService {
  // ====== CONFIG ======
  // PBKDF2 params (adjust iterations higher for more security, balance with UX)
  static const int _pbkdf2Iterations = 310000; // ~Chrome 2023 baseline level
  static const int _pbkdf2KeyLength = 32;      // 256-bit key
  static const int _saltBytes = 16;            // 128-bit random salt
  static const int _nonceBytes = 12;           // 96-bit nonce for AES-GCM
  final RxValue<NewWalletResult?> _newWalletResultRx = RxValue<NewWalletResult?>(null);

  String? _mnemonic;
  EthPrivateKey? _privateKey;

  String? get mnemonic => _mnemonic;
  EthPrivateKey? get privateKey => _privateKey;
  
  String? from_address;
  String? to_address;


  // Secure storage keys (you can version these)
  static const String _vaultKey = 'wallet_vault_v1';
  static const String _pincodeKey = "wallet_pincode";
  
  static final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(aOptions: const AndroidOptions(
    encryptedSharedPreferences: true,
  ));
  final Random _rng = Random.secure();

  List<Map<String, dynamic>> transactions = [];

  void init() {
  }
  // ====== PUBLIC API ======

  /// Generate a new 12 or 24-word mnemonic (128 or 256 bits of entropy).
  String generateMnemonic({int strength = 128}) {
    return bip39.generateMnemonic(strength: strength);
  }

  /// Validate if a mnemonic phrase is valid
  bool validateMnemonic(String mnemonic) {
    return bip39.validateMnemonic(mnemonic);
  }

  /// Derive Ethereum private key (hex) from BIP39 mnemonic using BIP32 path m/44'/60'/0'/0/0.
  /// Returns a hex private key without 0x prefix.
  String privateKeyFromMnemonic(String mnemonic) {
    final seed = bip39.mnemonicToSeed(mnemonic); // Uint8List
    final root = bip32.BIP32.fromSeed(seed);
    final child = root.derivePath("m/44'/60'/0'/0/0");
    final privKey = child.privateKey;
    if (privKey == null) {
      throw StateError('Failed to derive private key from mnemonic.');
    }
    return HEX.encode(privKey); // hex string (no 0x)
  }

  /// Validate and normalize a private key (with or without 0x prefix)
  String normalizePrivateKey(String privateKey) {
    // Remove any whitespace
    String normalized = privateKey.trim();
    
    // Remove 0x prefix if present
    if (normalized.startsWith('0x')) {
      normalized = normalized.substring(2);
    }
    
    // Validate length (64 characters for 32 bytes)
    if (normalized.length != 64) {
      throw ArgumentError('Invalid private key length. Expected 64 hex characters.');
    }
    
    // Validate it's valid hex
    try {
      HEX.decode(normalized);
    } catch (e) {
      throw ArgumentError('Invalid private key format. Must be valid hexadecimal.');
    }
    
    return normalized;
  }

  /// Derive AES-GCM key bytes from a password + salt using PBKDF2(HMAC-SHA256).
  Future<SecretKey> _deriveKey(String password, Uint8List salt) async {
    final pbkdf2 = Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: _pbkdf2Iterations,
      bits: _pbkdf2KeyLength * 8,
    );
    return await pbkdf2.deriveKey(
      secretKey: SecretKey(utf8.encode(password)),
      nonce: salt, // in PBKDF2 this is the salt
    );
  }

  /// Encrypt arbitrary bytes (e.g., mnemonic or private key) with password using AES-GCM.
  /// Returns base64 string of: salt(16) | nonce(12) | ciphertext+tag
  Future<String> encryptWithPassword({
    required String password,
    required Uint8List plaintext,
  }) async {
    final salt = _randomBytes(_saltBytes);
    final key = await _deriveKey(password, salt);

    final nonce = _randomBytes(_nonceBytes);
    final algorithm = AesGcm.with256bits();
    final secretBox = await algorithm.encrypt(
      plaintext,
      secretKey: key,
      nonce: nonce,
    );

    // Concatenate salt | nonce | cipher+tag
    final payload = Uint8List(
      salt.length + nonce.length + secretBox.cipherText.length + secretBox.mac.bytes.length,
    );
    int o = 0;
    payload.setAll(o, salt); o += salt.length;
    payload.setAll(o, nonce); o += nonce.length;
    payload.setAll(o, secretBox.cipherText); o += secretBox.cipherText.length;
    payload.setAll(o, secretBox.mac.bytes);

    return base64Encode(payload);
  }

  /// Decrypt base64(salt|nonce|cipher+tag) with password and return plaintext bytes.
  Future<Uint8List> decryptWithPassword({
    required String password,
    required String base64Payload,
  }) async {
    final payload = base64Decode(base64Payload);
    if (payload.length < _saltBytes + _nonceBytes + 16) {
      throw ArgumentError('Payload too short');
    }

    int o = 0;
    final salt = payload.sublist(o, o + _saltBytes); o += _saltBytes;
    final nonce = payload.sublist(o, o + _nonceBytes); o += _nonceBytes;

    // remaining is cipher+tag; last 16 bytes is GCM tag
    final macLen = 16;
    final cipherLen = payload.length - o - macLen;
    final cipherText = payload.sublist(o, o + cipherLen); o += cipherLen;
    final macBytes = payload.sublist(o);

    final key = await _deriveKey(password, Uint8List.fromList(salt));
    final algorithm = AesGcm.with256bits();

    final secretBox = SecretBox(
      cipherText,
      nonce: nonce,
      mac: Mac(macBytes),
    );

    final clear = await algorithm.decrypt(
      secretBox,
      secretKey: key,
    );
    return Uint8List.fromList(clear);
  }

  /// Create a new wallet (mnemonic + private key), encrypt it with password, and persist as a vault.
  /// Returns: address, mnemonic (optional to show once), and tx-ready private key (not stored in clear).
  Future<NewWalletResult> createAndStoreWallet(String password, {bool returnMnemonic = true}) async {
    final mnemonic = generateMnemonic(strength: 128); // 12 words
    final privHex = privateKeyFromMnemonic(mnemonic);

    // You can choose what you encrypt: mnemonic (preferred) or private key.
    final encryptedVault = await encryptWithPassword(
      password: password,
      plaintext: Uint8List.fromList(utf8.encode(mnemonic)),
    );

    await _secureStorage.write(key: _vaultKey, value: encryptedVault);
    await _secureStorage.write(key: _pincodeKey, value: password);
    final creds = EthPrivateKey.fromHex(privHex);
    _privateKey = creds;
    logger.d("addrss is ${privateKey?.address.hex}");
    final address = await creds.extractAddress();
    final newWalletResult = NewWalletResult(
        address: address.hex,
        mnemonic: returnMnemonic ? mnemonic : null,
        privateKeyHex: privHex, // do NOT persist this in clear anywhere
        encryptedVaultBase64: encryptedVault,
      );
    _newWalletResultRx.value = newWalletResult;
    return newWalletResult;
  }

  /// Import an existing wallet from mnemonic phrase
  Future<NewWalletResult> importFromMnemonic(String mnemonic, String password, {bool returnMnemonic = false}) async {
    // Validate the mnemonic
    if (!validateMnemonic(mnemonic)) {
      throw ArgumentError('Invalid mnemonic phrase');
    }

    final privHex = privateKeyFromMnemonic(mnemonic);

    // Encrypt and store the mnemonic
    final encryptedVault = await encryptWithPassword(
      password: password,
      plaintext: Uint8List.fromList(utf8.encode(mnemonic)),
    );
    logger.d("entered password is $password, $encryptedVault");
    await _secureStorage.write(key: _vaultKey, value: encryptedVault);
    await _secureStorage.write(key: _pincodeKey, value: password);
    // Verify the writes were successful
    final verifyVault = await _secureStorage.read(key: _vaultKey);
    final verifyPincode = await _secureStorage.read(key: _pincodeKey);
    
    if (verifyVault == null || verifyPincode == null) {
      throw Exception('Secure storage write verification failed');
    }
    final vault = await _secureStorage.read(key: _vaultKey);
    final values = await _secureStorage.readAll();

    logger.d("Stored vault is $vault, $values");
    final creds = EthPrivateKey.fromHex(privHex);
    final address = await creds.extractAddress();
    _mnemonic = mnemonic;
    _privateKey = creds;    
    final result = NewWalletResult(
      address: address.hex,
      mnemonic: returnMnemonic ? mnemonic : null,
      privateKeyHex: privHex,
      encryptedVaultBase64: encryptedVault,
    );
    
    _newWalletResultRx.value = result;
    return result;
  }

  /// Import an existing wallet from private key
  Future<NewWalletResult> importFromPrivateKey(String privateKey, String password) async {
    // Normalize and validate the private key
    final normalizedPrivHex = normalizePrivateKey(privateKey);

    // Since we're importing from private key, we don't have a mnemonic
    // We'll encrypt the private key instead
    final encryptedVault = await encryptWithPassword(
      password: password,
      plaintext: Uint8List.fromList(HEX.decode(normalizedPrivHex)),
    );

    await _secureStorage.write(key: _vaultKey, value: encryptedVault);
    await _secureStorage.write(key: _pincodeKey, value: password);

    final creds = EthPrivateKey.fromHex(normalizedPrivHex);
    _privateKey = creds;
    _mnemonic = "";
    final address = await creds.extractAddress();
    
    final result = NewWalletResult(
      address: address.hex,
      mnemonic: null, // No mnemonic when importing from private key
      privateKeyHex: normalizedPrivHex,
      encryptedVaultBase64: encryptedVault,
    );

    _newWalletResultRx.value = result;
    return result;
  }

  /// [OPTIONAL] Import from keystore file (JSON format)
  /// This is a more complex implementation that would require parsing the JSON
  /// and decrypting with the provided password
  Future<NewWalletResult> importFromKeystore(String keystoreJson, String password) async {
    // This is a simplified implementation - you might want to use a proper
    // keystore parsing library like flutter_web3_keystore
    
    try {
      final jsonMap = jsonDecode(keystoreJson);
      
      // Basic validation (adjust based on your keystore format)
      if (jsonMap['crypto'] == null || jsonMap['address'] == null) {
        throw ArgumentError('Invalid keystore format');
      }
      
      // Extract the encrypted data
      final crypto = jsonMap['crypto'];
      final cipherText = base64Decode(crypto['ciphertext'] as String);
      final salt = base64Decode(crypto['kdfparams']['salt'] as String);
      final iv = base64Decode(crypto['cipherparams']['iv'] as String);
      
      // Derive key using the same parameters as in the keystore
      // This would need to be adapted based on the specific KDF used
      final derivedKey = await _deriveKey(password, salt);
      
      // Decrypt using the appropriate algorithm (typically AES-128-CTR or AES-256-GCM)
      // This is a simplified example - actual implementation depends on keystore format
      final algorithm = AesGcm.with256bits();
      final secretBox = SecretBox(
        cipherText,
        nonce: iv,
        mac: Mac(Uint8List(0)), // Some keystores might include a MAC
      );
      
      final decrypted = await algorithm.decrypt(
        secretBox,
        secretKey: derivedKey,
      );
      
      final privateKeyBytes = Uint8List.fromList(decrypted);
      final privateKeyHex = HEX.encode(privateKeyBytes);
      
      // Store the decrypted private key encrypted with our own method
      return await importFromPrivateKey(privateKeyHex, password);
      
    } catch (e) {
      throw ArgumentError('Failed to decrypt keystore: $e');
    }
  }

  /// Unlock the wallet by decrypting the stored vault with password. Returns mnemonic & derived privKey.
  Future<UnlockedWallet> unlockFromStorage(String password) async {
    final b64 = await _secureStorage.read(key: _vaultKey);
    if (b64 == null) {
      throw StateError('No wallet vault found.');
    }
    
    final clear;
    
    // Try to decode as mnemonic first (UTF8)
    try {
      clear = await decryptWithPassword(password: password, base64Payload: b64);
      final mnemonic = utf8.decode(clear);
      if (validateMnemonic(mnemonic)) {
        final privHex = privateKeyFromMnemonic(mnemonic);
        final creds = EthPrivateKey.fromHex(privHex);
        _privateKey = creds;
        _mnemonic = mnemonic;
        final address = await creds.extractAddress();
        return UnlockedWallet(
          address: address.hex,
          mnemonic: mnemonic,
          privateKeyHex: privHex,
        );
      }
    } catch (e) {
      // Not a mnemonic, try as private keyr
      return UnlockedWallet(
        address: "",
        mnemonic: "",
        privateKeyHex: ""
      );
    }
    
    // If not a valid mnemonic, assume it's a private key
    final privHex = HEX.encode(clear);
    final normalizedPrivHex = normalizePrivateKey(privHex);
    final creds = EthPrivateKey.fromHex(normalizedPrivHex);
    final address = await creds.extractAddress();
    
    return UnlockedWallet(
      address: address.hex,
      mnemonic: "", // No mnemonic when stored as private key
      privateKeyHex: normalizedPrivHex,
    );
  }

  /// Overwrite & remove stored vault (use for "lock & wipe" or "reset" flows).
  Future<void> deleteVault() async {
    await _secureStorage.delete(key: _vaultKey);
  }

  // ====== HELPERS ======
  Uint8List _randomBytes(int length) {
    final b = Uint8List(length);
    for (var i = 0; i < length; i++) {
      b[i] = _rng.nextInt(256);
    }
    return b;
  }

  Future<bool> doesWalletExist() async {
    final vault = await _secureStorage.read(key: _vaultKey);
    final pincode = await _secureStorage.read(key: _pincodeKey);
    final values = await _secureStorage.readAll();
    return vault != null;
  }
}

class CryptoHelper {
  static CryptoService get service => locator<CryptoService>();

  static EthPrivateKey? get privateKey => service.privateKey;
  static String? get mnemonic => service.mnemonic;
  static String? get address => service.privateKey?.address.hex ?? "";
}
