import 'package:flutter/material.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/utils/utils.dart';

class AccountProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  UserModel? _accountUser;
  UserModel? get accountUser => _accountUser;
  set accountUser(UserModel? model) {
    _accountUser = model;
    notifyListeners();
  }

  Future<void> init(BuildContext context, {UserModel? model}) async {
    this.context = context;
    accountUser = model;
  }
}
