import 'package:observable_ish/observable_ish.dart';
import 'package:stacked/stacked.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';

import 'package:insoblok/locator.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

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

  Future<void> setUser(UserModel model) async {
    var isUpdated = await FirebaseHelper.setUser(model);
    if (isUpdated) {
      _userRx.value = model;
    }
    notifyListeners();
  }

  Future<void> setSessionStatus({SessionStatus? session}) async {
    _sessionStatusRx.value = session;
    notifyListeners();
  }

  Future<UserModel?> signIn() async {
    try {
      await FirebaseHelper.signInFirebase();
      var credential = FirebaseHelper.userCredential;
      var uid = credential.user?.uid;
      if (uid != null) {
        logger.d(uid);
        var user = await FirebaseHelper.getUser(uid);
        if (user == null) {
          user = UserModel(
            id: uid,
            regdate: kFullDateTimeFormatter.format(DateTime.now().toUtc()),
            updateDate: kFullDateTimeFormatter.format(DateTime.now().toUtc()),
          );
          var saved = await FirebaseHelper.setUser(user);
          if (!saved) {
            return null;
          }
        }
        _userRx.value = user;
        return user;
      }
    } catch (e) {
      logger.e(e);
    }
    return null;
  }
}

class AuthHelper {
  static AuthService get service => locator<AuthService>();

  static Future<void> setSessionStatus({SessionStatus? session}) =>
      service.setSessionStatus(session: session);

  static UserModel? get user => service.user;
  static bool get isLoggedIn => service.isLoggedIn;
  static SessionStatus? get sessionStatus => service.sessionStatus;

  static Future<void> setUser(UserModel model) => service.setUser(model);
}
