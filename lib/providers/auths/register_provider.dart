import 'package:flutter/material.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class RegisterProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  int _pageIndex = 0;
  int get pageIndex => _pageIndex;
  set pageIndex(int i) {
    _pageIndex = i;
    obscureText = true;
    notifyListeners();
  }

  late UserModel _user;

  Future<void> init(
    BuildContext context, {
    required String walletAddress,
  }) async {
    this.context = context;
    _user = UserModel(walletAddress: walletAddress);
  }

  void updateFirstName(String name) {
    _user = _user.copyWith(firstName: name);
    notifyListeners();
  }

  void updateLastName(String name) {
    _user = _user.copyWith(lastName: name);
    notifyListeners();
  }

  void updateEmailAddress(String s) {
    _user = _user.copyWith(email: s);
    notifyListeners();
  }

  bool _obscureText = true;
  bool get obscureText => _obscureText;
  set obscureText(bool f) {
    _obscureText = f;
    notifyListeners();
  }

  String _biometric = '';
  String get biometric => _biometric;
  set biometric(String s) {
    _biometric = s;
    notifyListeners();
  }

  set website(String s) {
    _user = _user.copyWith(website: s);
    notifyListeners();
  }

  void updateCity(String s) {
    _user = _user.copyWith(city: s);
    notifyListeners();
  }

  void updateCountry(String s) {
    _user = _user.copyWith(country: s);
    notifyListeners();
  }

  Future<void> onClickRegister() async {
    if ((_user.firstName?.isEmpty ?? true) ||
        (_user.lastName?.isEmpty ?? true)) {
      AIHelpers.showToast(msg: "Please input your name!");
      return;
    }

    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        await AuthHelper.signUp(_user);
        Routers.goToMainPage(context);
      } catch (e) {
        setError(e);
      } finally {
        notifyListeners();
      }
    }());
    if (hasError) {
      AIHelpers.showToast(msg: modelError.toString());
    }
  }
}
