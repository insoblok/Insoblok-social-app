import 'package:flutter/material.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/utils/utils.dart';

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

  Future<void> onClickNext() async {
    Routers.goToRegisterPage(context, user: _user);
  }
}
