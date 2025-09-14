import 'dart:io';

import 'package:collection/collection.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/locator.dart';

class AccountService with ListenableServiceMixin {
  
  final TransferService transferService = TransferService();
  final List<TastescoreModel> _scores = [];

  final UserModel? owner = AuthHelper.user;
  AccountService() {
    getUserScore(owner?.id ?? "");
    getTransfers(owner?.id ?? "");
  }

  List<TastescoreModel> get scores =>
      _scores..sort((b, a) => a.timestamp!.difference(b.timestamp!).inSeconds);

  int get totalScore {
    var result = 0;

    for (var score in scores) {
      result += (score.bonus ?? 0);
    }
    return result;
  }

  int get availableXP {
    return totalScore - transferValues[0].toInt();
    // return 5000;
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

  XpInSoModel? _selectXpInSo;
  XpInSoModel? get selectXpInSo => _selectXpInSo;
  set selectXpInSo(XpInSoModel? model) {
    _selectXpInSo = model;
    notifyListeners();
  }

  var textController = TextEditingController();

  Future<void> getUserScore(String userId) async {
    if (userId.isEmpty) return;
    try {
      _scores.clear();
      var s = await tastScoreService.getScoresByUser(userId);
      _scores.addAll(s);
    } catch (e) {
      logger.e(e);
    } finally {
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

  final List<TransferModel> _transfers = [];

  List<double> get transferValues =>
      transferService.getXpToInsoBalance(_transfers);

  List<double> get transferValues1 =>
      transferService.getInsoToUsdtBalance(_transfers);

  Future<void> getTransfers(String userId) async {
    if (userId.isEmpty) return;
    try {
      _transfers.clear();
      var t = await transferService.getTransfers(userId);
      _transfers.addAll(t);
    } catch (e) {
      logger.e(e);
    } finally {
    }
  }

}
