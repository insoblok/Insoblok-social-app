import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    notifyListeners();
  }

  void updateEmail(String s) {
    account = account.copyWith(email: s);
  }

  void updatePassword(String s) {
    account = account.copyWith(password: s);
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

  void updateCountry(String s) {
    account = account.copyWith(country: s);
  }

  void onClickUpdateProfile() {
    if (isBusy) return;
    clearErrors();

    Navigator.of(context).pop(account);
  }
}
