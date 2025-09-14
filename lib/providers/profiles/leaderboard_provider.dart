import 'package:flutter/material.dart';

import 'package:collection/collection.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class UserScoreModel {
  final String id;
  final List<TastescoreModel> scores;

  UserScoreModel({required this.id, required this.scores});

  set date(String s) {
    date = s;
  }

  int get xpDay {
    var result = 0;
    for (var score in scores) {
      if ((score.updateDate?.year == DateTime.now().year) &&
          (score.updateDate?.month == DateTime.now().month) &&
          (score.updateDate?.day == DateTime.now().day)) {
        result += score.bonus ?? 0;
      }
    }
    return result;
  }

  int get xpWeek {
    var result = 0;
    for (var score in scores) {
      if ((score.updateDate?.year == DateTime.now().year) &&
          (getWeekNumber(score.updateDate!) == getWeekNumber(DateTime.now()))) {
        result += score.bonus ?? 0;
      }
    }
    return result;
  }

  int get xpMonth {
    var result = 0;
    for (var score in scores) {
      if ((score.updateDate?.year == DateTime.now().year) &&
          (score.updateDate?.month == DateTime.now().month)) {
        result += score.bonus ?? 0;
      }
    }
    return result;
  }

  int get xpTotal {
    var result = 0;
    for (var score in scores) {
      result += score.bonus ?? 0;
    }
    return result;
  }

  List<UserLevelModel> get userLevels =>
      AppSettingHelper.appSettingModel?.userLevel ?? [];

  UserLevelModel get userLevel {
    for (var userLevel in userLevels) {
      if ((userLevel.min ?? 0) <= xpTotal &&
          xpTotal < (userLevel.max ?? 1000000000)) {
        return userLevel;
      }
    }
    return userLevels.first;
  }

  double get indicatorValue {
    var min = userLevel.min ?? 0;
    var max = userLevel.max ?? 0;
    return (xpTotal - min) / (max - min);
  }

}

class LeaderboardProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  final List<UserScoreModel> _leaderboard = [];
  List<UserScoreModel> get leaderboard => _leaderboard;

  List<UserScoreModel> get dailyLeaderboard =>
      _leaderboard.sorted((b, a) => a.xpDay - b.xpDay).toList();
  List<UserScoreModel> get weeklyLeaderboard =>
      _leaderboard.sorted((b, a) => a.xpWeek - b.xpWeek).toList();

  List<UserScoreModel> get monthlyLeaderboard =>
      _leaderboard.sorted((b, a) => a.xpMonth - b.xpMonth).toList();

  List<UserScoreModel> get totalLeaderboard =>
      _leaderboard.sorted((b, a) => a.xpTotal - b.xpTotal).toList();


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
        var scores = await tastScoreService.getScoreList();
        var newMap = groupBy(scores, (obj) => obj.userId);

        for (var key in newMap.keys) {
          if (key != null) {
            var leader = UserScoreModel(id: key, scores: newMap[key] ?? []);
            _leaderboard.add(leader);
          }
        }

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
}
