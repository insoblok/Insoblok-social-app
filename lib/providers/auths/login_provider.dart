import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class LoginProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  Future<void> init(BuildContext context) async {
    this.context = context;
  }

  Future<void> login() async {
    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        await AuthHelper.service.signIn();
      } catch (e) {
        setError(e);
        logger.e(e);
      } finally {
        notifyListeners();
      }
    }());

    if (hasError) {
      Fluttertoast.showToast(msg: modelError.toString());
    } else {
      if (AuthHelper.user?.firstName != null) {
        Routers.goToMainPage(context);
      } else {
        Routers.goToRegisterPage(context);
      }
    }
  }
}
