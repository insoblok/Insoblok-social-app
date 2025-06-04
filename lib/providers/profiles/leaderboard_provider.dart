import 'package:flutter/material.dart';
import 'package:insoblok/models/models.dart';

import 'package:insoblok/utils/utils.dart';

import '../../services/services.dart';

class LeaderboardProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  List<UserModel?> _users = [];
  List<UserModel?> get users => _users;

  int _tabIndex = 0;
  int get tabIndex => _tabIndex;
  set tabIndex(int d) {
    _tabIndex = d;
    notifyListeners();
  }

  Future<void> init(BuildContext context) async {
    this.context = context;
    fetchData();
  }

  Future<void> fetchData() async {
    if (isBusy) return;
    clearErrors();
    await runBusyFuture(() async {
      try {
        var s = await userService.getAllUsers();
        _users.addAll(s);
        _users.addAll(s);
        _users.addAll(s);
        _users.addAll(s);
        _users.addAll(s);

        logger.d(_users.length);
      } catch (e) {
        logger.e(e);
        setError(e);
      } finally {
        notifyListeners();
      }
    }());
    if (hasError) {
      AIHelpers.showToast(msg: modelError.toString());
    }
  }

  String selectDate() {
    if (tabIndex == 0) return 'weekly';
    if (tabIndex == 1) return 'weekly';
    if (tabIndex == 2) return 'montly';
    return ' daily';
  }
}
