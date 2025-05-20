import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:insoblok/extensions/extensions.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class AccountPrivateProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  late UserModel _account;
  UserModel get account => _account;
  set account(UserModel model) {
    _account = model;
    notifyListeners();
  }

  final List<UserCountryModel> _countries = [];
  List<UserCountryModel> get countries => _countries;

  Future<void> init(BuildContext context) async {
    this.context = context;
    account = AuthHelper.user ?? UserModel();
    fetchData();
  }

  Future<void> fetchData() async {
    final String response = await rootBundle.loadString(
      'assets/data/country.json',
    );
    final data = await json.decode(response);
    _countries.addAll((data as List).map((d) => UserCountryModel.fromJson(d)));

    if (account.country?.isNotEmpty ?? false) {
      var c = countries.firstWhere((e) => e.name == account.country);
      country = c;
    }

    notifyListeners();
  }

  String _email = '';
  String get email => _email;
  set email(String s) {
    _email = s;
    notifyListeners();
  }

  void updateEmail(String s) {
    if (account.email?.isEmpty ?? true) {
      email = s;
    }
  }

  String _password = '';
  String get password => _password;
  set password(String s) {
    _password = s;
    notifyListeners();
  }

  void updatePassword(String s) {
    password = s;
  }

  String _confirmedPassword = '';
  String get confirmedPassword => _confirmedPassword;
  set confirmedPassword(String s) {
    _confirmedPassword = s;
    notifyListeners();
  }

  void updateConfirm(String s) {
    confirmedPassword = s;
  }

  void updateCity(String s) {
    account = account.copyWith(city: s);
  }

  UserCountryModel? _country;
  UserCountryModel? get country => _country;
  set country(UserCountryModel? model) {
    _country = model;
    notifyListeners();
  }

  void updateCountry(UserCountryModel? s) {
    country = s;
  }

  void updateWallet(String s) {}

  void onClickUpdateProfile() async {
    if (account.email?.isEmpty ?? true) {
      if (!(email.isEmailValid)) {
        Fluttertoast.showToast(msg: 'No matched email!');
        return;
      }
      if (password != confirmedPassword) {
        Fluttertoast.showToast(msg: 'No matched password!');
        return;
      }
    }

    if (isBusy) return;
    clearErrors();

    account = account.copyWith(
      country: country?.name,
      email: email,
      password: password,
    );

    await runBusyFuture(() async {
      try {
        await AuthHelper.updateUser(account);
        Fluttertoast.showToast(msg: 'Successfully updated user profile!');
        Navigator.of(context).pop(account);
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

    // Navigator.of(context).pop(account);
  }
}
