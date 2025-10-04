import 'package:flutter/material.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/utils/utils.dart';

class RegisterFirstProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  late UserModel _user;
  bool get biometricEnabled => _user.biometricEnabled ?? true;

  Future<void> init(
    BuildContext context, {
    required UserModel userModel,
  }) async {
    this.context = context;
    _user = userModel;
  }

  void updateFirstName(String name) {
    _user = _user.copyWith(firstName: name);
    notifyListeners();
  }

  void updateLastName(String name) {
    _user = _user.copyWith(lastName: name);
    notifyListeners();
  }

  Future<void> onClickNext() async {
    Routers.goToRegisterSecondPage(context, user: _user);
  }

  void updateBiometric(bool value) {
    _user = _user.copyWith(biometricEnabled: value);
    notifyListeners();
  }
}
