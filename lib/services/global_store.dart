// lib/services/global_store.dart
import 'package:shared_preferences/shared_preferences.dart';

class GlobalStore {
  static final GlobalStore _i = GlobalStore._();
  GlobalStore._();
  factory GlobalStore() => _i;

  // Example global(s)
  bool isVybeCamEnabled = false;
  String? walletAddress;

  Future<void> load() async {
    final sp = await SharedPreferences.getInstance();
    isVybeCamEnabled = sp.getBool('isVybeCamEnabled') ?? false;
    walletAddress    = sp.getString('walletAddress');
  }

  Future<void> save() async {
    final sp = await SharedPreferences.getInstance();
    await sp.setBool('isVybeCamEnabled', isVybeCamEnabled);
    if (walletAddress != null) {
      await sp.setString('walletAddress', walletAddress!);
    } else {
      await sp.remove('walletAddress');
    }
  }
}
