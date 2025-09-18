import 'package:flutter/foundation.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:observable_ish/observable_ish.dart';
import 'package:stacked/stacked.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/locator.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class AuthService with ListenableServiceMixin {
  
  final RxValue<UserModel?> _userRx = RxValue<UserModel?>(null);
  UserModel? get user => _userRx.value;
  set user(UserModel? u) {
    _userRx.value = u;
    notifyListeners();
  }

  final RxValue<UserCredential?> _credentialRx = RxValue<UserCredential?>(null);
  UserCredential? get credential => _credentialRx.value;

  final RxValue<bool?> _isVybeScan = RxValue<bool?>(null);
  bool? get isVybeScan => _isVybeScan.value;

  bool get isLoggedIn => user?.walletAddress != null;

  AuthService() {
    listenToReactiveValues([_userRx, _credentialRx, _isVybeScan]);
  
    
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

    _userService.getUserUpdated().listen((updatedUser) {
      if (updatedUser?.id == user?.id) {
        _userRx.value = updatedUser;
        notifyListeners();
      }
    });
  }

  Future<void> updateStatus(String status) async {
    logger.d(status);
    await userService.updateUser(user!.copyWith(status: status));
  }

  Future<UserModel?> signIn(String walletAddress, bool isVybeScan) async {
    await FirebaseHelper.signInFirebase();
    var credential = FirebaseHelper.userCredential;
    _credentialRx.value = credential;

    var uid = credential.user?.uid;
    var authUser = await userService.getUserByWalletAddress(walletAddress);
    if (authUser != null) {
      var tastescoreService = TastescoreService();
      var rewardDate = await tastescoreService.loginScore(authUser);

      var newUser = authUser.copyWith(
        uid: uid,
        updateDate: DateTime.now(),
        rewardDate: rewardDate,
      );
      await userService.updateUser(newUser);
      _userRx.value = newUser;
      _isVybeScan.value = isVybeScan;
      return newUser;
    }

    return null;
  }

  Future<UserModel?> signUp(UserModel newUser) async {
    var uid = credential?.user?.uid;
    if (uid != null) {
      var ipAddress = IpAddress(type: RequestType.json);
      var data = await ipAddress.getIpAddress();

      var resultUser = await userService.createUser(
        newUser.copyWith(
          uid: uid,
          ipAddress: kDebugMode ? kDefaultIpAddress : data['ip'],
          nickId: newUser.fullName.trim().replaceAll(' ', '').toLowerCase(),
          rewardDate: 0,
          timestamp: DateTime.now(),
          updateDate: DateTime.now(),
        ),
      );
      _userRx.value = resultUser;
    } else {
      throw Exception('Failed firebase connection!');
    }
    return null;
  }

  Future<void> signInWithGoogle({String? walletAddress}) async {
    // await FirebaseHelper.signInWithGoogle();
    // var credential = FirebaseHelper.userCredential;
    // var uid = credential.user?.uid;
    // if (uid != null) {
    //   logger.d(uid);
    //   var ipAddress = IpAddress(type: RequestType.json);
    //   var data = await ipAddress.getIpAddress();
    //   var newUser = await userService.getUser(id);
    //   if (newUser != null) {
    //     final tastScoreService = TastescoreService();
    //     var reward = await tastScoreService.loginScore(newUser);
    //     if (newUser.walletAddress != null) {
    //       newUser = newUser.copyWith(
    //         ipAddress: kDebugMode ? kDefaultIpAddress : data['ip'],
    //         rewardDate: reward,
    //         updateDate: DateTime.now(),
    //       );
    //     } else {
    //       newUser = newUser.copyWith(
    //         walletAddress: walletAddress,
    //         ipAddress: kDebugMode ? kDefaultIpAddress : data['ip'],
    //         rewardDate: reward,
    //         updateDate: DateTime.now(),
    //       );
    //     }

    //     await updateUser(newUser);
    //   } else {
    //     newUser = UserModel(
    //       uid: uid,
    //       email: credential.user?.email,
    //       firstName: credential.user?.displayName,
    //       nickId:
    //           credential.user?.displayName
    //               ?.trim()
    //               .replaceAll(' ', '')
    //               .toLowerCase(),
    //       walletAddress: walletAddress,
    //       ipAddress: kDebugMode ? kDefaultIpAddress : data['ip'],
    //       rewardDate: 0,
    //       timestamp: DateTime.now(),
    //       updateDate: DateTime.now(),
    //     );
    //     newUser = await userService.createUser(newUser);
    //     _userRx.value = newUser;
    //   }
    // } else {
    //   throw Exception('No matched email or password!');
    // }
  }
  
}

class AuthHelper {
  static AuthService get service => locator<AuthService>();

  static UserModel? get user => service.user;
  static bool get isLoggedIn => service.isLoggedIn;

  static Future<UserModel?> signIn(String walletAddress, bool isVybeScan) =>
      service.signIn(walletAddress, isVybeScan);
  static Future<UserModel?> signUp(UserModel user) => service.signUp(user);
  static Future<void> signInWithGoogle({String? walletAddress}) =>
      service.signInWithGoogle(walletAddress: walletAddress);

  static Future<void> updateUser(UserModel model) => service.updateUser(model);
  static Future<void> updateStatus(String status) =>
      service.updateStatus(status);
}
