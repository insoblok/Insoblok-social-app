import 'package:observable_ish/observable_ish.dart';
import 'package:stacked/stacked.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';

import 'package:insoblok/locator.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';

class AuthService with ListenableServiceMixin {
  final RxValue<UserModel?> _userRx = RxValue<UserModel?>(null);
  UserModel? get user => _userRx.value;

  final RxValue<SessionStatus?> _sessionStatusRx =
      RxValue<SessionStatus?>(null);
  SessionStatus? get sessionStatus => _sessionStatusRx.value;

  bool get isLoggedIn => user?.walletAddress != null;

  AuthService() {
    listenToReactiveValues([
      _userRx,
      _sessionStatusRx,
    ]);
  }

  Future<void> init() async {
    var credential = FirebaseHelper.userCredential;
    var uid = credential.user?.uid;
    if (uid != null) {
      final user = await FirebaseHelper.getUser(uid);
      _userRx.value = user;
    }
  }

  Future<void> setUser(UserModel model) async {
    _userRx.value = model;
    notifyListeners();
  }

  Future<void> setSessionStatus({SessionStatus? session}) async {
    // await DBHelper.setUser(model);
    _sessionStatusRx.value = session;
    notifyListeners();
  }
}

class AuthHelper {
  static AuthService get service => locator<AuthService>();

  static UserModel? get user => service.user;
  static bool get isLoggedIn => service.isLoggedIn;
  static SessionStatus? get sessionStatus => service.sessionStatus;

  static Future<void> setUser(UserModel model) => service.setUser(model);
  static Future<void> setSessionStatus({SessionStatus? session}) =>
      service.setSessionStatus(session: session);
}
