import 'package:observable_ish/observable_ish.dart';
import 'package:stacked/stacked.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';

import 'package:aiavatar/locator.dart';
import 'package:aiavatar/models/models.dart';
import 'package:aiavatar/services/services.dart';

class AuthService with ListenableServiceMixin {
  final RxValue<UserModel?> _userRx = RxValue<UserModel?>(null);
  UserModel? get user => _userRx.value;

  final RxValue<SessionStatus?> _sessionStatusRx =
      RxValue<SessionStatus?>(null);
  SessionStatus? get sessionStatus => _sessionStatusRx.value;

  bool get isLoggedIn => user?.address != null;

  AuthService() {
    listenToReactiveValues([
      _userRx,
      _sessionStatusRx,
    ]);
  }

  Future<void> init() async {
    var user = await DBHelper.user;
    _userRx.value = user;
  }

  Future<void> setUser(UserModel model) async {
    await DBHelper.setUser(model);
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
