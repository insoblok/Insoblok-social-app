import 'package:flutter/material.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/locator.dart';

class RegisterSecondProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  late UserModel _user;

  Future<void> init(
    BuildContext context, {
    required UserModel userModel,
  }) async {
    this.context = context;
    _user = userModel;
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
    await FirebaseHelper.signInFirebase();
    if (isBusy) return;
    clearErrors();
    int xpScore = 0;
    if (_user.firstName != null && _user.firstName != '') {
      xpScore = xpScore + 50;
    }
    if (_user.lastName != null && _user.lastName != '') {
      xpScore = xpScore + 50;
    }
    if (_user.country != null &&
        _user.country != '' &&
        _user.city != null &&
        _user.city != '') {
      xpScore = xpScore + 75;
    }
    if (_user.website != null && _user.website != '') {
      xpScore = xpScore + 25;
    }

    await runBusyFuture(() async {
      try {
        await AuthHelper.signUp(_user);
        if (xpScore > 0) await tastScoreService.registerScore(xpScore);
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
