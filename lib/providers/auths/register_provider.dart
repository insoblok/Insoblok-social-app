import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:insoblok/extensions/extensions.dart';
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

  String _password = '';
  String get password => _password;
  set password(String s) {
    _password = s;
    notifyListeners();
  }

  String _rePassword = '';
  String get rePassword => _rePassword;
  set rePassword(String s) {
    _rePassword = s;
    notifyListeners();
  }

  String _biometric = '';
  String get biometric => _biometric;
  set biometric(String s) {
    _biometric = s;
    notifyListeners();
  }

  String _website = '';
  String get website => _website;
  set website(String s) {
    _website = s;
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

  Future<void> onClickConfirm() async {
    if ((_user.firstName?.isEmpty ?? true) ||
        (_user.lastName?.isEmpty ?? true)) {
      Fluttertoast.showToast(msg: S.current.register_error_name);
      return;
    }
    if (!(_user.email?.isEmailValid ?? false)) {
      Fluttertoast.showToast(msg: 'No matched email!');
      return;
    }
    if (password != rePassword) {
      Fluttertoast.showToast(msg: 'No matched password!');
      return;
    }

    if (isBusy) return;
    clearErrors();

    logger.d(_user.toJson());

    await runBusyFuture(() async {
      try {
        await FirebaseHelper.convertAnonymousToPermanent(
          email: _user.email!,
          password: password,
        );
        await AuthHelper.setUser(
          _user.copyWith(
            nickId: _user.fullName.replaceAll(' ', '').toLowerCase(),
          ),
        );
        Routers.goToMainPage(context);
      } catch (e) {
        setError(e);
      } finally {
        notifyListeners();
      }
    }());
    if (hasError) {
      Fluttertoast.showToast(msg: modelError.toString());
    }
  }
}
