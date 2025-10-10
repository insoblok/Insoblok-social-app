import 'package:flutter/material.dart';

import 'package:collection/collection.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';


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
      _leaderboard
      .sorted((b, a) => a.xpWeek - b.xpWeek)
      .toList()
      .asMap()
      .entries
      .where((entry) => entry.key < LEADER_BOARD_DISPLAY_LENGTH) // Get first 50 items
      .map((entry) => entry.value) // Extract just the values
      .toList();

  List<UserScoreModel> get monthlyLeaderboard =>
      _leaderboard
      .sorted((b, a) => a.xpMonth - b.xpMonth)
      .toList()
      .asMap()
      .entries
      .where((entry) => entry.key < LEADER_BOARD_DISPLAY_LENGTH) // Get first 50 items
      .map((entry) => entry.value) // Extract just the values
      .toList();

  List<UserScoreModel> get totalLeaderboard =>
      _leaderboard
      .sorted((b, a) => a.xpTotal - b.xpTotal)
      .toList()
      .asMap()
      .entries
      .where((entry) => entry.key < LEADER_BOARD_DISPLAY_LENGTH) // Get first 50 items
      .map((entry) => entry.value) // Extract just the values
      .toList();


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
