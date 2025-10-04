import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/utils/utils.dart';


class LocalAuthService {
  // static const FlutterSecureStorage _secureStorage = FlutterSecureStorage(
  //   aOptions: AndroidOptions(
  //     encryptedSharedPreferences: true,
  //     // requireAuthentication: true,
  //   ),
  //   iOptions: IOSOptions(
  //     // accessibility: IOSAccessibility.biometry_any_or_device_passcode,
  //     accountName: 'WalletApp',
  //   ),
  // );
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  final ApiService apiService = ApiService(baseUrl: "");

  LocalAuthentication _localAuth = LocalAuthentication();
  
  // Storage keys
  static const String _pincodeKey = "wallet_pincode";

  final CryptoService cryptoService = CryptoService();  
  /// Check if biometric authentication is available
  Future<bool> isFaceIDAvailable() async {
    try {
      final bool isAvailable = await _localAuth.isDeviceSupported();
      final bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
      final List<BiometricType> availableBiometrics = await _localAuth.getAvailableBiometrics();
      Map<String, dynamic> logData = {};
      logData["isAvailable"] = isAvailable;
      logData["canCheckBiometrics"] = canCheckBiometrics;
      logData["availableBiometrics"] = availableBiometrics.join(",");
      apiService.logRequest(logData);
      return isAvailable && canCheckBiometrics && availableBiometrics.isNotEmpty;
    } catch (e) {
      logger.d('Error checking biometric availability: $e');
      apiService.logRequest({"result": "failed", "message": 'Error checking biometric availability: $e  : isFaceIDAvailable'});
      return false;
    }
  }
  
  /// Get available biometric types
  /// Check if Face ID is available
  
  /// Authenticate using biometrics
  Future<bool> authenticateWithBiometrics({
    String reason = 'Authenticate to access your wallet',
  }) async {
    final available = await isFaceIDAvailable();
    if (!available) {
      logger.d("Face Unlock is not available");
      apiService.logRequest({"result": "failed", "message": 'Face Unlock is not available: authenticateWithBiometrics ${await AIHelpers.getIPAddress()}'});

      // return false;
    }
    try {
      final bool isAuthenticated = await _localAuth.authenticate(
        localizedReason: 'Use Face Recognition',
        authMessages: [
          AndroidAuthMessages(
            signInTitle: 'Wallet Sign In',
            cancelButton: 'Cancel',
            biometricHint: 'Place your face in front of your phone',
            biometricNotRecognized: 'Biometric not recognized. Try again.',
            biometricRequiredTitle: 'Biometric Required',
            biometricSuccess: 'Biometric authentication successful',
            deviceCredentialsRequiredTitle: 'Device Credential Required',
            deviceCredentialsSetupDescription: 'Device credential setup description',
            goToSettingsButton: 'Go to Settings',
            goToSettingsDescription: 'Please set up your biometric authentication',
          ),
          // const IOSAuthMessages(
          //   cancelButton: 'Cancel',
          //   goToSettingsButton: 'Settings',
          //   goToSettingsDescription: 'Please set up your Face ID or Touch ID.',
          //   lockOut: 'Authentication is locked out. Please use device passcode.',
          //   localizedFallbackTitle: 'Use Passcode',
          // ),
        ],
        options: const AuthenticationOptions(
          biometricOnly: true, // Allow device passcode as fallback
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
      apiService.logRequest({"result": "failed", "message": 'localAuth.authenticate result is $isAuthenticated : authenticateWithBiometrics ${await AIHelpers.getIPAddress()}'});
      
      return isAuthenticated;
    } catch (e) {
      logger.d('Biometric authentication error: $e');
      apiService.logRequest({"result": "Failed", "message": "Biometric authentication error: $e  : authenticateWithBiometrics"});
      return false;
    }
  }
  
  Future<UnlockedWallet> accessWalletWithFaceId() async {
    UnlockedWallet result = UnlockedWallet(address: "", mnemonic: "", privateKeyHex: "");
    try {
      final pinCode = await _secureStorage.read(key: _pincodeKey);
      logger.d("Pincode is $pinCode");
      if (pinCode == null || pinCode.isEmpty) return result; 
      final bool authenticated = await authenticateWithBiometrics(
        reason: 'Access your wallet',
      );
      if (!authenticated) {
        apiService.logRequest({"result": "Failed", "message": "authresult is false: accessWalletWithFaceId"});
        return result;
      }
      result = await cryptoService.unlockFromStorage(pinCode);
      
    } catch (e) {
      logger.d('Error accessing wallet: ${e.toString()}');
      apiService.logRequest({"result": "Failed", "message": "Error accessing wallet: ${e.toString()}  : accessWalletWithFaceId"});
    }
    return result;
  }
  
  /// Reset wallet (delete all data)
  Future<void> resetWallet() async {
    await _secureStorage.delete(key: _pincodeKey);
  }
  

}