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
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/locator.dart';

class CryptoService {
  // ====== CONFIG ======
  // PBKDF2 params (adjust iterations higher for more security, balance with UX)
  static const int _pbkdf2Iterations = 310000; // ~Chrome 2023 baseline level
  static const int _pbkdf2KeyLength = 32; // 256-bit key
  static const int _saltBytes = 16; // 128-bit random salt
  static const int _nonceBytes = 12; // 96-bit nonce for AES-GCM
  final RxValue<NewWalletResult?> _newWalletResultRx =
      RxValue<NewWalletResult?>(null);

  String? _mnemonic;
  EthPrivateKey? _privateKey;

  String? get mnemonic => _mnemonic;
  EthPrivateKey? get privateKey => _privateKey;

  String? from_address;
  String? to_address;

  // Secure storage keys (you can version these)
  static const String _vaultKey = 'wallet_vault_v1';
  static const String _pincodeKey = "wallet_pincode";

  static final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(
    aOptions: const AndroidOptions(encryptedSharedPreferences: true),
  );
  final Random _rng = Random.secure();

  List<Map<String, dynamic>> transactions = [];

  void init() {}
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

  /// Derive private key from BIP39 mnemonic using a custom BIP32 derivation path.
  /// Returns a hex private key without 0x prefix.
  String privateKeyFromMnemonicWithPath(
    String mnemonic,
    String derivationPath,
  ) {
    final seed = bip39.mnemonicToSeed(mnemonic); // Uint8List
    final root = bip32.BIP32.fromSeed(seed);
    final child = root.derivePath(derivationPath);
    final privKey = child.privateKey;
    if (privKey == null) {
      throw StateError(
        'Failed to derive private key from mnemonic with path: $derivationPath',
      );
    }
    return HEX.encode(privKey); // hex string (no 0x)
  }

  /// Derive XRP public key from mnemonic using BIP32 path m/44'/144'/0'/0/0.
  /// Returns the public key in hex format.
  String xrpPublicKeyFromMnemonic(String mnemonic) {
    final seed = bip39.mnemonicToSeed(mnemonic);
    final root = bip32.BIP32.fromSeed(seed);
    final child = root.derivePath("m/44'/144'/0'/0/0"); // XRP derivation path
    final publicKey = child.publicKey;
    // publicKey should never be null from BIP32, but we check for safety
    return HEX.encode(publicKey); // Public key in hex
  }

  /// Convert XRP public key (hex) to XRP address (base58 encoded, starts with 'r').
  /// Uses API endpoint to convert public key to proper XRP address format.
  /// Tries multiple API endpoints to find one that works.
  Future<String> xrpPublicKeyToAddress(String publicKeyHex) async {
    try {
      final apiService = ApiService(baseUrl: INSOBLOK_WALLET_URL);

      // Try endpoint 1: /evm/public-key-to-address
      try {
        final body1 = {"public_key": publicKeyHex, "chain": "xrp"};
        final response1 = await apiService.postRequest(
          "/evm/public-key-to-address",
          body1,
        );
        if (response1 is Map && response1["address"] != null) {
          final address = response1["address"].toString();
          if (address.startsWith('r') || address.startsWith('X')) {
            logger.d("XRP address from /evm/public-key-to-address: $address");
            return address;
          }
        }
      } catch (e) {
        logger.d("Trying alternative endpoint for XRP address conversion: $e");
      }

      // Try endpoint 2: /evm/balance with public_key (might return address)
      try {
        final body2 = {"chain": "xrp", "public_key": publicKeyHex};
        final response2 = await apiService.postRequest("/evm/balance", body2);
        if (response2 is Map && response2["address"] != null) {
          final address = response2["address"].toString();
          if (address.startsWith('r') || address.startsWith('X')) {
            logger.d("XRP address from /evm/balance: $address");
            return address;
          }
        }
      } catch (e) {
        logger.d("Balance endpoint doesn't return address: $e");
      }

      // Try endpoint 3: /xrp/public-key-to-address (alternative path)
      try {
        final body3 = {"public_key": publicKeyHex};
        final response3 = await apiService.postRequest(
          "/xrp/public-key-to-address",
          body3,
        );
        if (response3 is Map && response3["address"] != null) {
          final address = response3["address"].toString();
          if (address.startsWith('r') || address.startsWith('X')) {
            logger.d("XRP address from /xrp/public-key-to-address: $address");
            return address;
          }
        }
      } catch (e) {
        logger.d("XRP-specific endpoint not available: $e");
      }

      // If all API endpoints fail, log warning but don't throw
      // This allows wallet creation to continue - we'll try to convert later
      logger.w(
        "Failed to convert XRP public key to address. All API endpoints failed. "
        "Will store public key for later conversion.",
      );

      // Return a marker indicating this needs conversion
      // Format: "PK:<public_key_hex>" so we can identify it later
      return "PK:$publicKeyHex";
    } catch (e) {
      logger.e("Error converting XRP public key to address: $e");
      // Return marker instead of throwing to allow wallet creation
      return "PK:$publicKeyHex";
    }
  }

  /// Check if an XRP address is actually a public key marker
  bool isXrpPublicKeyMarker(String address) {
    return address.startsWith("PK:");
  }

  /// Extract public key from marker format
  String extractXrpPublicKey(String marker) {
    if (marker.startsWith("PK:")) {
      return marker.substring(3);
    }
    return marker;
  }

  /// Try to convert stored XRP public key to address (for existing wallets)
  Future<String?> tryConvertStoredXrpPublicKey(String storedValue) async {
    if (isXrpPublicKeyMarker(storedValue)) {
      final publicKey = extractXrpPublicKey(storedValue);
      try {
        final address = await xrpPublicKeyToAddress(publicKey);
        if (address.startsWith('r') || address.startsWith('X')) {
          if (address.length >= 25 && address.length <= 35) {
            logger.d(
              "Successfully converted stored XRP public key to address: $address",
            );
            return address;
          }
        }
      } catch (e) {
        logger.w("Failed to convert stored XRP public key: $e");
      }
    } else if (storedValue.length == 64 &&
        RegExp(r'^[0-9a-fA-F]+$').hasMatch(storedValue)) {
      // Old format: just public key hex without marker
      try {
        final address = await xrpPublicKeyToAddress(storedValue);
        if (address.startsWith('r') || address.startsWith('X')) {
          if (address.length >= 25 && address.length <= 35) {
            logger.d(
              "Successfully converted old format XRP public key to address: $address",
            );
            return address;
          }
        }
      } catch (e) {
        logger.w("Failed to convert old format XRP public key: $e");
      }
    }
    return null;
  }

  /// Retrieve stored wallet addresses from secure storage.
  /// Returns a map of chain -> address.
  Future<Map<String, String>> getStoredAddresses() async {
    try {
      final addressesJson = await _secureStorage.read(key: 'wallet_addresses');
      if (addressesJson != null && addressesJson.isNotEmpty) {
        final addresses = jsonDecode(addressesJson) as Map<String, dynamic>;
        return addresses.map((key, value) => MapEntry(key, value.toString()));
      }
    } catch (e) {
      logger.e("Error reading stored addresses: $e");
    }
    return {};
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
      throw ArgumentError(
        'Invalid private key length. Expected 64 hex characters.',
      );
    }

    // Validate it's valid hex
    try {
      HEX.decode(normalized);
    } catch (e) {
      throw ArgumentError(
        'Invalid private key format. Must be valid hexadecimal.',
      );
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
      salt.length +
          nonce.length +
          secretBox.cipherText.length +
          secretBox.mac.bytes.length,
    );
    int o = 0;
    payload.setAll(o, salt);
    o += salt.length;
    payload.setAll(o, nonce);
    o += nonce.length;
    payload.setAll(o, secretBox.cipherText);
    o += secretBox.cipherText.length;
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
    final salt = payload.sublist(o, o + _saltBytes);
    o += _saltBytes;
    final nonce = payload.sublist(o, o + _nonceBytes);
    o += _nonceBytes;

    // remaining is cipher+tag; last 16 bytes is GCM tag
    final macLen = 16;
    final cipherLen = payload.length - o - macLen;
    final cipherText = payload.sublist(o, o + cipherLen);
    o += cipherLen;
    final macBytes = payload.sublist(o);

    final key = await _deriveKey(password, Uint8List.fromList(salt));
    final algorithm = AesGcm.with256bits();

    final secretBox = SecretBox(cipherText, nonce: nonce, mac: Mac(macBytes));

    final clear = await algorithm.decrypt(secretBox, secretKey: key);
    return Uint8List.fromList(clear);
  }

  /// Create a new wallet (mnemonic + private key), encrypt it with password, and persist as a vault.
  /// Returns: address, mnemonic (optional to show once), and tx-ready private key (not stored in clear).
  /// Also generates and stores addresses for USDT and XRP.
  Future<NewWalletResult> createAndStoreWallet(
    String password, {
    bool returnMnemonic = true,
  }) async {
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
    logger.d("ETH address is ${privateKey?.address.hex}");
    final ethAddress = await creds.extractAddress();

    // Generate addresses for different tokens
    Map<String, String> addresses = {};

    // ETH address
    addresses["ethereum"] = ethAddress.hex;
    logger.d("ETH address: ${addresses["ethereum"]}");

    // USDT address (ERC-20 token, uses same address as ETH)
    addresses["usdt"] = ethAddress.hex;
    logger.d("USDT address: ${addresses["usdt"]}");

    // XRP address - derive public key and convert to XRP address format (starts with 'r')
    try {
      final xrpPublicKey = xrpPublicKeyFromMnemonic(mnemonic);
      logger.d("XRP public key: $xrpPublicKey");

      // Convert public key to XRP address format (must start with 'r')
      final xrpAddress = await xrpPublicKeyToAddress(xrpPublicKey);

      // Validate the address format
      if (xrpAddress.startsWith('r') || xrpAddress.startsWith('X')) {
        if (xrpAddress.length >= 25 && xrpAddress.length <= 35) {
          addresses["xrp"] = xrpAddress;
          logger.d("XRP address generated successfully: ${addresses["xrp"]}");
        } else {
          logger.w(
            "XRP address length invalid: ${xrpAddress.length} (expected 25-35). Storing as marker.",
          );
          addresses["xrp"] = xrpAddress; // Store anyway, might be marker format
        }
      } else if (xrpAddress.startsWith("PK:")) {
        // API conversion failed, storing public key marker for later conversion
        addresses["xrp"] = xrpAddress;
        logger.w(
          "XRP address conversion failed. Stored public key marker for later conversion.",
        );
      } else {
        logger.w(
          "XRP address format unclear: $xrpAddress. Storing as-is for later conversion.",
        );
        addresses["xrp"] = xrpAddress;
      }
    } catch (e) {
      logger.e("Failed to derive XRP address: $e");
      addresses["xrp"] = ""; // Set empty if derivation fails completely
    }

    // Store addresses in secure storage for future use
    final addressesJson = jsonEncode(addresses);
    await _secureStorage.write(key: 'wallet_addresses', value: addressesJson);
    logger.d("Stored all addresses: $addresses");

    final newWalletResult = NewWalletResult(
      address: ethAddress.hex,
      mnemonic: returnMnemonic ? mnemonic : null,
      privateKeyHex: privHex, // do NOT persist this in clear anywhere
      encryptedVaultBase64: encryptedVault,
      addresses: addresses,
    );
    _newWalletResultRx.value = newWalletResult;
    return newWalletResult;
  }

  /// Import an existing wallet from mnemonic phrase
  /// Also generates and stores addresses for USDT and XRP.
  Future<NewWalletResult> importFromMnemonic(
    String mnemonic,
    String password, {
    bool returnMnemonic = false,
  }) async {
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

    logger.d("Stored vault is $vault");
    final creds = EthPrivateKey.fromHex(privHex);
    final ethAddress = await creds.extractAddress();
    _mnemonic = mnemonic;
    _privateKey = creds;

    // Generate addresses for different tokens
    Map<String, String> addresses = {};

    // ETH address
    addresses["ethereum"] = ethAddress.hex;
    logger.d("ETH address: ${addresses["ethereum"]}");

    // USDT address (ERC-20 token, uses same address as ETH)
    addresses["usdt"] = ethAddress.hex;
    logger.d("USDT address: ${addresses["usdt"]}");

    // XRP address - derive public key and convert to XRP address format (starts with 'r')
    try {
      final xrpPublicKey = xrpPublicKeyFromMnemonic(mnemonic);
      logger.d("XRP public key: $xrpPublicKey");

      // Convert public key to XRP address format (must start with 'r')
      final xrpAddress = await xrpPublicKeyToAddress(xrpPublicKey);

      // Validate the address format
      if (xrpAddress.startsWith('r') || xrpAddress.startsWith('X')) {
        if (xrpAddress.length >= 25 && xrpAddress.length <= 35) {
          addresses["xrp"] = xrpAddress;
          logger.d("XRP address generated successfully: ${addresses["xrp"]}");
        } else {
          logger.w(
            "XRP address length invalid: ${xrpAddress.length} (expected 25-35). Storing as marker.",
          );
          addresses["xrp"] = xrpAddress; // Store anyway, might be marker format
        }
      } else if (xrpAddress.startsWith("PK:")) {
        // API conversion failed, storing public key marker for later conversion
        addresses["xrp"] = xrpAddress;
        logger.w(
          "XRP address conversion failed. Stored public key marker for later conversion.",
        );
      } else {
        logger.w(
          "XRP address format unclear: $xrpAddress. Storing as-is for later conversion.",
        );
        addresses["xrp"] = xrpAddress;
      }
    } catch (e) {
      logger.e("Failed to derive XRP address: $e");
      addresses["xrp"] = ""; // Set empty if derivation fails completely
    }

    // Store addresses in secure storage for future use
    final addressesJson = jsonEncode(addresses);
    await _secureStorage.write(key: 'wallet_addresses', value: addressesJson);
    logger.d("Stored all addresses: $addresses");

    final result = NewWalletResult(
      address: ethAddress.hex,
      mnemonic: returnMnemonic ? mnemonic : null,
      privateKeyHex: privHex,
      encryptedVaultBase64: encryptedVault,
      addresses: addresses,
    );

    _newWalletResultRx.value = result;
    return result;
  }

  /// Import an existing wallet from private key
  Future<NewWalletResult> importFromPrivateKey(
    String privateKey,
    String password,
  ) async {
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
  Future<NewWalletResult> importFromKeystore(
    String keystoreJson,
    String password,
  ) async {
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
      return UnlockedWallet(address: "", mnemonic: "", privateKeyHex: "");
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
    return vault != null;
  }
}

class CryptoHelper {
  static CryptoService get service => locator<CryptoService>();

  static EthPrivateKey? get privateKey => service.privateKey;
  static String? get mnemonic => service.mnemonic;
  static String? get address => service.privateKey?.address.hex ?? "";

  /// Get address for a specific chain (ethereum, usdt, xrp, etc.)
  static Future<String?> getAddressForChain(String chain) async {
    final addresses = await service.getStoredAddresses();
    return addresses[chain.toLowerCase()];
  }

  /// Get all stored addresses
  static Future<Map<String, String>> getAllAddresses() async {
    return await service.getStoredAddresses();
  }
}
