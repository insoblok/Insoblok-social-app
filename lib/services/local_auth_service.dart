import 'dart:convert';
import 'dart:typed_data';
import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
// import 'package:local_auth_ios/local_auth_ios.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:crypto/crypto.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:hex/hex.dart';

class LocalAuthService {
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      // requireAuthentication: true,
    ),
    iOptions: IOSOptions(
      // accessibility: IOSAccessibility.biometry_any_or_device_passcode,
      accountName: 'WalletApp',
    ),
  );
  
  static LocalAuthentication _localAuth = LocalAuthentication();
  
  // Storage keys
  static const String _walletSeedKey = 'wallet_seed_encrypted';
  static const String _walletSetupKey = 'wallet_setup_complete';
  static const String _userIdKey = 'user_biometric_id';
  static const String _walletAddressKey = 'wallet_address';
  
  /// Check if biometric authentication is available
  static Future<bool> isBiometricAvailable() async {
    try {
      final bool isAvailable = await _localAuth.isDeviceSupported();
      final bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
      final List<BiometricType> availableBiometrics = await _localAuth.getAvailableBiometrics();
      
      return isAvailable && canCheckBiometrics && availableBiometrics.isNotEmpty;
    } catch (e) {
      print('Error checking biometric availability: $e');
      return false;
    }
  }
  
  /// Get available biometric types
  static Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      print('Error getting available biometrics: $e');
      return [];
    }
  }
  
  /// Check if Face ID is available
  static Future<bool> isFaceIdAvailable() async {
    final biometrics = await getAvailableBiometrics();
    return biometrics.contains(BiometricType.face);
  }
  
  /// Authenticate using biometrics
  static Future<bool> authenticateWithBiometrics({
    String reason = 'Authenticate to access your wallet',
  }) async {
    try {
      final bool isAuthenticated = await _localAuth.authenticate(
        localizedReason: 'Use Device Passcode',
        authMessages: [
          AndroidAuthMessages(
            signInTitle: 'Wallet Authentication',
            cancelButton: 'Cancel',
            biometricHint: 'Touch sensor',
            biometricNotRecognized: 'Biometric not recognized. Try again.',
            biometricRequiredTitle: 'Biometric Required',
            biometricSuccess: 'Biometric authentication successful',
            deviceCredentialsRequiredTitle: 'Device Credential Required',
            deviceCredentialsSetupDescription: 'Device credential setup description',
            goToSettingsButton: 'Go to Settings',
            goToSettingsDescription: 'Please set up your biometric authentication',
          ),
          // IOSAuthMessages(
          //   cancelButton: 'Cancel',
          //   goToSettingsButton: 'Settings',
          //   goToSettingsDescription: 'Please set up your Face ID or Touch ID.',
          //   lockOut: 'Authentication is locked out. Please use device passcode.',
          //   localizedFallbackTitle: 'Use Passcode',
          // ),
        ],
        options: const AuthenticationOptions(
          biometricOnly: false, // Allow device passcode as fallback
          stickyAuth: true,
        ),
      );
      
      return isAuthenticated;
    } catch (e) {
      print('Biometric authentication error: $e');
      return false;
    }
  }
  
  /// Check if wallet is already set up
  static Future<bool> isWalletSetup() async {
    final setup = await _secureStorage.read(key: _walletSetupKey);
    return setup == 'true';
  }
  
  /// Create a new wallet with Face ID protection
  static Future<Map<String, String>?> createWalletWithFaceId() async {
    try {
      // First authenticate with biometrics
      final bool authenticated = await authenticateWithBiometrics(
        reason: 'Set up your secure wallet with Face ID',
      );
      
      if (!authenticated) {
        throw Exception('Biometric authentication failed');
      }
      
      // Generate unique user ID based on biometric authentication
      final userId = _generateUniqueUserId();
      
      // Generate cryptographically secure seed
      final seed = _generateSecureSeed(userId);
      
      // Generate mnemonic from seed
      final mnemonic = bip39.entropyToMnemonic(HEX.encode(seed));
      
      // Generate wallet from mnemonic
      final walletData = _generateWalletFromMnemonic(mnemonic);
      
      // Store encrypted wallet data
      await _storeWalletSecurely(seed, walletData['address']!, userId);
      
      // Mark wallet as set up
      await _secureStorage.write(key: _walletSetupKey, value: 'true');
      
      return {
        'mnemonic': mnemonic,
        'privateKey': walletData['privateKey']!,
        'address': walletData['address']!,
        'userId': userId,
      };
      
    } catch (e) {
      print('Error creating wallet: $e');
      return null;
    }
  }
  
  /// Access existing wallet with Face ID
  static Future<Map<String, String>?> accessWalletWithFaceId() async {
    try {
      // Check if wallet is set up
      if (!await isWalletSetup()) {
        return null;
      }
      
      // Authenticate with biometrics
      final bool authenticated = await authenticateWithBiometrics(
        reason: 'Access your wallet',
      );
      
      if (!authenticated) {
        return null;
      }
      
      // Retrieve stored data
      final encryptedSeed = await _secureStorage.read(key: _walletSeedKey);
      final storedUserId = await _secureStorage.read(key: _userIdKey);
      final walletAddress = await _secureStorage.read(key: _walletAddressKey);
      
      if (encryptedSeed == null || storedUserId == null) {
        throw Exception('Wallet data not found');
      }
      
      // Decrypt seed
      final seed = _decryptSeed(encryptedSeed, storedUserId);
      
      // Generate mnemonic from seed
      final mnemonic = bip39.entropyToMnemonic(HEX.encode(seed));
      
      // Generate wallet from mnemonic
      final walletData = _generateWalletFromMnemonic(mnemonic);
      
      return {
        'mnemonic': mnemonic,
        'privateKey': walletData['privateKey']!,
        'address': walletData['address']!,
        'userId': storedUserId,
      };
      
    } catch (e) {
      print('Error accessing wallet: $e');
      return null;
    }
  }
  
  /// Reset wallet (delete all data)
  static Future<void> resetWallet() async {
    await _secureStorage.delete(key: _walletSeedKey);
    await _secureStorage.delete(key: _walletSetupKey);
    await _secureStorage.delete(key: _userIdKey);
    await _secureStorage.delete(key: _walletAddressKey);
  }
  
  /// Generate unique user ID
  static String _generateUniqueUserId() {
    final random = Random.secure();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final randomBytes = List<int>.generate(16, (i) => random.nextInt(256));
    final combined = '$timestamp${base64.encode(randomBytes)}';
    final hash = sha256.convert(utf8.encode(combined));
    return base64.encode(hash.bytes).substring(0, 32);
  }
  
  /// Generate cryptographically secure seed
  static Uint8List _generateSecureSeed(String userId) {
    final random = Random.secure();
    final entropy = List<int>.generate(32, (i) => random.nextInt(256));
    final userBytes = utf8.encode(userId);
    final combined = [...entropy, ...userBytes];
    final hash = sha256.convert(combined);
    return Uint8List.fromList(hash.bytes);
  }
  
  /// Generate wallet from mnemonic
  static Map<String, String> _generateWalletFromMnemonic(String mnemonic) {
    try {
      // Generate seed from mnemonic
      final seed = bip39.mnemonicToSeed(mnemonic);
      
      // Generate private key (first 32 bytes of seed)
      final privateKey = HEX.encode(seed.take(32).toList());
      
      // Generate Ethereum address from private key
      final address = _generateEthereumAddress(privateKey);
      
      return {
        'privateKey': privateKey,
        'address': address,
      };
    } catch (e) {
      throw Exception('Failed to generate wallet from mnemonic: $e');
    }
  }
  
  /// Generate Ethereum address from private key
  static String _generateEthereumAddress(String privateKey) {
    try {
      // This is a simplified address generation
      // In production, use proper secp256k1 curve and keccak256 hashing
      final privateKeyBytes = HEX.decode(privateKey);
      final hash = sha256.convert(privateKeyBytes);
      final addressBytes = hash.bytes.take(20).toList();
      return '0x${HEX.encode(addressBytes)}';
    } catch (e) {
      throw Exception('Failed to generate address: $e');
    }
  }
  
  /// Store wallet data securely
  static Future<void> _storeWalletSecurely(Uint8List seed, String address, String userId) async {
    // Encrypt seed with user ID
    final encryptedSeed = _encryptSeed(seed, userId);
    
    // Store encrypted data
    await _secureStorage.write(key: _walletSeedKey, value: encryptedSeed);
    await _secureStorage.write(key: _userIdKey, value: userId);
    await _secureStorage.write(key: _walletAddressKey, value: address);
  }
  
  /// Encrypt seed with user ID
  static String _encryptSeed(Uint8List seed, String userId) {
    final userBytes = utf8.encode(userId);
    final key = sha256.convert(userBytes).bytes;
    
    // Simple XOR encryption (use proper encryption in production)
    final encrypted = <int>[];
    for (int i = 0; i < seed.length; i++) {
      encrypted.add(seed[i] ^ key[i % key.length]);
    }
    
    return base64.encode(encrypted);
  }
  
  /// Decrypt seed with user ID
  static Uint8List _decryptSeed(String encryptedSeed, String userId) {
    final userBytes = utf8.encode(userId);
    final key = sha256.convert(userBytes).bytes;
    final encrypted = base64.decode(encryptedSeed);
    
    // Simple XOR decryption
    final decrypted = <int>[];
    for (int i = 0; i < encrypted.length; i++) {
      decrypted.add(encrypted[i] ^ key[i % key.length]);
    }
    
    return Uint8List.fromList(decrypted);
  }
  
  /// Get wallet address without full authentication (for display purposes)
  static Future<String?> getWalletAddress() async {
    try {
      return await _secureStorage.read(key: _walletAddressKey);
    } catch (e) {
      print('Error getting wallet address: $e');
      return null;
    }
  }
}