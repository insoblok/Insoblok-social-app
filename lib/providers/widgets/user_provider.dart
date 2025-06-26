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

  late String _id;
  int? _score;

  void init(BuildContext context, {required String id, int? score}) async {
    this.context = context;
    _id = id;
    _score = score;
    fetchUser();
  }

  UserModel? _owner;
  UserModel? get owner => _owner;
  set owner(UserModel? model) {
    _owner = model;
    notifyListeners();
  }

  List<UserLevelModel> get userLevels =>
      AppSettingHelper.appSettingModel?.userLevel ?? [];

  UserLevelModel get userLevel {
    for (var userLevel in userLevels) {
      if ((userLevel.min ?? 0) <= (_score ?? 0) &&
          (_score ?? 0) < (userLevel.max ?? 1000000000)) {
        return userLevel;
      }
    }
    return userLevels.first;
  }

  Future<void> fetchUser() async {
    try {
      owner = await userService.getUser(_id);
    } catch (e) {
      setError(e);
      logger.e(e);
    } finally {
      notifyListeners();
    }
  }

  Color getRankColor(int pos) {
    if (pos == 0) {
      return AIColors.gold;
    } else if (pos == 1) {
      return AIColors.silver;
    } else if (pos == 2) {
      return AIColors.bronze;
    }
    return Theme.of(context).colorScheme.secondary.withAlpha(16);
  }

  Future<void> goToDetailPage() async {
    if (isBusy) return;
    clearErrors();

    await Routers.goToAccountPage(context, user: owner);
  }

  Future<void> goToTastescorePage() async {
    if (isBusy) return;
    clearErrors();

    await Routers.goToTastescorePage(context, user: owner);
  }
}
