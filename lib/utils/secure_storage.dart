import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage();

  static Future<void> saveMnemonic(String mnemonic) async {
    await _storage.write(key: 'mnemonic', value: mnemonic);
  }

  static Future<String?> getMnemonic() async {
    return await _storage.read(key: 'mnemonic');
  }

  static Future<void> deleteMnemonic() async {
    await _storage.delete(key: 'mnemonic');
  }
}
