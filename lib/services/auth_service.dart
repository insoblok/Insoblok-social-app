import 'package:flutter/foundation.dart';

import 'package:get_ip_address/get_ip_address.dart';
import 'package:observable_ish/observable_ish.dart';
import 'package:stacked/stacked.dart';

import 'package:insoblok/locator.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class AuthService with ListenableServiceMixin {
  final RxValue<UserModel?> _userRx = RxValue<UserModel?>(null);
  UserModel? get user => _userRx.value;

  bool get isLoggedIn => user?.walletAddress != null;

  AuthService() {
    listenToReactiveValues([_userRx]);
  }

  Future<void> updateUser(UserModel model) async {
    await userService.updateUser(model);
    _userRx.value = model;
    notifyListeners();
  }

  late UserService _userService;
  UserService get userService => _userService;

  void init() {
    _userService = UserService();
  }

  Future<void> updateStatus(String status) async {
    await userService.updateUser(user!.copyWith(status: status));
  }

  Future<void> signIn({String? walletAddress}) async {
    await FirebaseHelper.signInFirebase();
    var credential = FirebaseHelper.userCredential;
    var uid = credential.user?.uid;
    if (uid != null) {
      logger.d(uid);
      var newUser = await userService.getUser(uid);

      var ipAddress = IpAddress(type: RequestType.json);
      var data = await ipAddress.getIpAddress();

      if (newUser == null) {
        newUser = UserModel(
          uid: uid,
          walletAddress: walletAddress,
          ipAddress: kDebugMode ? kDefaultIpAddress : data['ip'],
        );
        newUser = await userService.createUser(newUser);
        _userRx.value = newUser;
      } else {
        newUser = newUser.copyWith(
          walletAddress: walletAddress,
          ipAddress: kDebugMode ? kDefaultIpAddress : data['ip'],
        );
        await updateUser(newUser);
      }
    }
  }

  Future<void> signInEmail({
    required String email,
    required String password,
    String? walletAddress,
  }) async {
    await FirebaseHelper.signInEmail(email: email, password: password);
    var credential = FirebaseHelper.userCredential;
    var uid = credential.user?.uid;
    if (uid != null) {
      logger.d(uid);
      var newUser = await userService.getUser(uid);
      if (newUser != null) {
        logger.d(newUser.toJson());

        var ipAddress = IpAddress(type: RequestType.json);
        var data = await ipAddress.getIpAddress();
        if (newUser.walletAddress != null) {
          newUser = newUser.copyWith(
            ipAddress: kDebugMode ? kDefaultIpAddress : data['ip'],
          );
        } else {
          newUser = newUser.copyWith(
            walletAddress: walletAddress,
            ipAddress: kDebugMode ? kDefaultIpAddress : data['ip'],
          );
        }

        await updateUser(newUser);
      } else {
        throw Exception('Failed server fatch!');
      }
    } else {
      throw Exception('No matched email or password!');
    }
  }

  final _tastScoreService = TastescoreService();
  TastescoreService get tastScoreService => _tastScoreService;

  Future<void> signInWithGoogle({String? walletAddress}) async {
    await FirebaseHelper.signInWithGoogle();
    var credential = FirebaseHelper.userCredential;
    var uid = credential.user?.uid;
    if (uid != null) {
      logger.d(uid);
      var ipAddress = IpAddress(type: RequestType.json);
      var data = await ipAddress.getIpAddress();
      var newUser = await userService.getUser(uid);
      if (newUser != null) {
        var reward = tastScoreService.loginScore(newUser);
        if (newUser.walletAddress != null) {
          newUser = newUser.copyWith(
            ipAddress: kDebugMode ? kDefaultIpAddress : data['ip'],
            rewardDate: reward,
          );
        } else {
          newUser = newUser.copyWith(
            walletAddress: walletAddress,
            ipAddress: kDebugMode ? kDefaultIpAddress : data['ip'],
            rewardDate: reward,
          );
        }

        await updateUser(newUser);
      } else {
        newUser = UserModel(
          uid: uid,
          email: credential.user?.email,
          firstName: credential.user?.displayName,
          nickId:
              credential.user?.displayName
                  ?.trim()
                  .replaceAll(' ', '')
                  .toLowerCase(),
          walletAddress: walletAddress,
          ipAddress: kDebugMode ? kDefaultIpAddress : data['ip'],
          rewardDate: 0,
        );
        newUser = await userService.createUser(newUser);
        _userRx.value = newUser;
      }
    } else {
      throw Exception('No matched email or password!');
    }
  }
}

class AuthHelper {
  static AuthService get service => locator<AuthService>();

  static UserModel? get user => service.user;
  static bool get isLoggedIn => service.isLoggedIn;

  static Future<void> updateUser(UserModel model) => service.updateUser(model);
  static Future<void> updateStatus(String status) =>
      service.updateStatus(status);
}
