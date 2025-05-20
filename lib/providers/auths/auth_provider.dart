import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class AuthProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  late ReownService _reownService;
  ReownService get reownService => _reownService;

  Future<void> init(BuildContext context) async {
    this.context = context;
    _reownService = ReownService(context);
  }

  String _emailAddress = '';
  String get emailAddress => _emailAddress;
  set emailAddress(String s) {
    _emailAddress = s;
    notifyListeners();
  }

  String _password = '';
  String get password => _password;
  set password(String s) {
    _password = s;
    notifyListeners();
  }

  bool _obscureText = true;
  bool get obscureText => _obscureText;
  set obscureText(bool f) {
    _obscureText = f;
    notifyListeners();
  }

  Future<void> onTapForgotPassword() async {
    Fluttertoast.showToast(msg: 'Not support this feature yet!');
  }

  Future<void> onTapLoginButton() async {
    if (!emailAddress.isEmailValid) {
      Fluttertoast.showToast(msg: 'No matched email!');
      return;
    }

    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        await reownService.init();
        if (reownService.isConnected) {
          logger.d(reownService.walletAddress);
          await AuthHelper.service.signInEmail(
            email: emailAddress,
            password: password,
            walletAddress: reownService.walletAddress,
          );

          Routers.goToMainPage(context);
        } else {
          setError('Failed wallet connected!');
        }
      } catch (e) {
        setError(e);
        logger.e(e);
      } finally {
        notifyListeners();
      }
    }());

    if (hasError) {
      Fluttertoast.showToast(msg: modelError.toString());
    }
  }
}
