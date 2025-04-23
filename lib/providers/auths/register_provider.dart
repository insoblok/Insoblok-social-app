import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:insoblok/generated/l10n.dart';
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

  Future<void> setUser(UserModel u) async {
    _user = u;
    notifyListeners();
  }

  Future<void> init(BuildContext context) async {
    this.context = context;
    _user = AuthHelper.user!;
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
    if ((_user.firstName?.isEmpty ?? true) ||
        (_user.lastName?.isEmpty ?? true)) {
      Fluttertoast.showToast(msg: S.current.register_error_name);
      return;
    }
    await runBusyFuture(() async {
      try {
        await AuthHelper.setUser(_user);
      } catch (e) {
        setError(e);
      } finally {
        notifyListeners();
      }
    }());
    if (hasError) {
      Fluttertoast.showToast(msg: modelError.toString());
    } else {
      Routers.goToLoginPage(context);
    }
  }
}
