import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

import 'leaderboard_provider.dart';

class AccountRewardProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  UserModel? _owner;
  UserModel? get owner => _owner;
  set owner(UserModel? u) {
    _owner = u;
    notifyListeners();
  }

  Future<void> init(BuildContext context, UserModel? user) async {
    this.context = context;
    _owner = user ?? AuthHelper.user;

    await getUserScore();
    await getUsersScoreList();
  }

  final List<TastescoreModel> _scores = [];
  List<TastescoreModel> get scores =>
      _scores..sort((b, a) => a.timestamp!.difference(b.timestamp!).inSeconds);

  int get totalScore {
    var result = 0;

    for (var score in scores) {
      result += (score.bonus ?? 0);
    }
    return result;
  }

  int get todayScore {
    var result = 0;
    var today = kDateCounterFormatter.format(DateTime.now());
    var year = DateTime.now().year;

    for (var score in scores) {
      var scoreDay = kDateCounterFormatter.format(score.timestamp!);
      var scoreYear = score.timestamp!.year;
      if (today == scoreDay && year == scoreYear) {
        result += (score.bonus ?? 0);
      }
    }
    return result;
  }

  List<UserLevelModel> get userLevels =>
      AppSettingHelper.appSettingModel?.userLevel ?? [];

  UserLevelModel get userLevel {
    for (var userLevel in userLevels) {
      if ((userLevel.min ?? 0) <= totalScore &&
          totalScore < (userLevel.max ?? 1000000000)) {
        return userLevel;
      }
    }
    return userLevels.first;
  }

  double get indicatorValue {
    var min = userLevel.min ?? 0;
    var max = userLevel.max ?? 0;
    return (totalScore - min) / (max - min);
  }

  bool _isLoadingScore = false;
  bool get isLoadingScore => _isLoadingScore;
  set isLoadingScore(bool f) {
    _isLoadingScore = f;
    notifyListeners();
  }

  Future<void> getUserScore() async {
    _isLoadingScore = true;
    try {
      _scores.clear();
      var s = await tastScoreService.getScoresByUser(owner!.uid!);
      _scores.addAll(s);
    } catch (e) {
      setError(e);
      logger.e(e);
    } finally {
      isLoadingScore = false;
    }
  }

  Future<void> getUserRank() async {}

  final List<UserScoreModel> _usersScoreList = [];
  List<UserScoreModel> get usersScoreList => _usersScoreList;

  List<UserScoreModel> get userTotalScores =>
      _usersScoreList.sorted((b, a) => a.xpTotal - b.xpTotal).toList();

  int _userRank = 0;
  int get userRank => _userRank;
  set userRank(int f) {
    _userRank = f;
    notifyListeners();
  }

  double get rankIndicatorValue {
    return userRank / 100;
  }

  Future<void> getUsersScoreList() async {
    try {
      var scores = await tastScoreService.getScoreList();
      var newMap = groupBy(scores, (obj) => obj.uid);

      for (var key in newMap.keys) {
        if (key != null) {
          var score = UserScoreModel(uid: key, scores: newMap[key] ?? []);
          _usersScoreList.add(score);
        }
      }
      var userRankIndex = 0;
      for (int i = 0; i < userTotalScores.length; i++) {
        logger.d(userTotalScores[i].uid);
        if (userTotalScores[i].uid == owner!.uid) {
          userRankIndex = i;
          break;
        }
      }
      userRank =
          ((userTotalScores.length - userRankIndex) *
                  100 /
                  userTotalScores.length)
              .toInt();
    } catch (e) {
      logger.e(e);
      setError(e);
    } finally {
      notifyListeners();
    }
  }
}
