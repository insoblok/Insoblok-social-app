// lib/services/global_store.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class GlobalStore {
  static final GlobalStore _i = GlobalStore._();
  GlobalStore._();
  factory GlobalStore() => _i;

  // Example global(s)
  bool isVybeCamEnabled = true;
  bool isRRCVideoCapture = true;
  String? walletAddress;

  // Credential storage
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  static const String _savedEmailKey = 'saved_email';
  static const String _savedPasswordKey = 'saved_password';
  static const String _autoLoginEnabledKey = 'auto_login_enabled';

  Future<void> load() async {
    final sp = await SharedPreferences.getInstance();
    isVybeCamEnabled = sp.getBool('isVybeCamEnabled') ?? false;
    isRRCVideoCapture = sp.getBool('isRRCVideoCapture') ?? false;
    walletAddress = sp.getString('walletAddress');
  }

  Future<void> save() async {
    final sp = await SharedPreferences.getInstance();
    await sp.setBool('isVybeCamEnabled', isVybeCamEnabled);
    await sp.setBool('isRRCVideoCapture', isRRCVideoCapture);
    if (walletAddress != null) {
      await sp.setString('walletAddress', walletAddress!);
    } else {
      await sp.remove('walletAddress');
    }
  }

  // Save credentials
  Future<void> saveCredentials({
    required String email,
    required String password,
    bool enableAutoLogin = true,
  }) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_savedEmailKey, email);
    await _secureStorage.write(key: _savedPasswordKey, value: password);
    await sp.setBool(_autoLoginEnabledKey, enableAutoLogin);
  }

  // Get saved email
  Future<String?> getSavedEmail() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(_savedEmailKey);
  }

  // Get saved password
  Future<String?> getSavedPassword() async {
    return await _secureStorage.read(key: _savedPasswordKey);
  }

  // Check if auto-login is enabled
  Future<bool> isAutoLoginEnabled() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getBool(_autoLoginEnabledKey) ?? false;
  }

  // Clear saved credentials
  Future<void> clearCredentials() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(_savedEmailKey);
    await sp.remove(_autoLoginEnabledKey);
    await _secureStorage.delete(key: _savedPasswordKey);
  }

  // Check if credentials exist
  // For login, we only need password (email is optional)
  Future<bool> hasSavedCredentials() async {
    final password = await getSavedPassword();
    // Password is required for login, email is optional
    return password != null && password.isNotEmpty;
  }
}
