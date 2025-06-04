import 'package:flutter/material.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class UserProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  late String _uid;
  late String? _date;

  void init(BuildContext context, {required String uid, String? date}) async {
    this.context = context;
    _uid = uid;
    _date = date;
    fetchUser();
    if (_date != null) {
      getUserScore(_date!);
    }
  }

  UserModel? _owner;
  UserModel? get owner => _owner;
  set owner(UserModel? model) {
    _owner = model;
    notifyListeners();
  }

  int _userScore = 0;
  int get userScore => _userScore;
  set userScore(int score) {
    _userScore = score;
    notifyListeners();
  }

  Future<void> fetchUser() async {
    try {
      owner = await userService.getUser(_uid);
    } catch (e) {
      setError(e);
      logger.e(e);
    } finally {
      notifyListeners();
    }
  }

  Future<void> getUserScore(String date) async {
    try {
      userScore = await tastScoreService.getUserScore(_uid, date);
      logger.d(userScore);
    } catch (e) {
      setError(e);
      logger.e(e);
    } finally {
      notifyListeners();
    }
  }

  Future<void> goToDetailPage() async {
    if (isBusy) return;
    clearErrors();

    await Routers.goToAccountPage(context, user: owner);
  }
}
