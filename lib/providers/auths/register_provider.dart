import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

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

  late UserModel _user;
  UserModel get user => _user;
  set user(UserModel u) {
    _user = u;
    notifyListeners();
  }

  Future<void> init(BuildContext context) async {
    this.context = context;
    user = AuthHelper.user!;
  }

  void updateFirstName(String name) {
    _user = _user.copyWith(firstName: name);
    notifyListeners();
  }

  void updateLastName(String name) {
    _user = _user.copyWith(lastName: name);
    notifyListeners();
  }

  Future<void> onClickConfirm() async {
    if ((user.firstName?.isEmpty ?? true) || (user.lastName?.isEmpty ?? true)) {
      Fluttertoast.showToast(msg: 'Please input your name!');
      return;
    }
    await AuthHelper.setUser(user);
    Routers.goToMainPage(context);
  }
}
