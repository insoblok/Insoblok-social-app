import 'package:collection/collection.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';

class AccountService with ListenableServiceMixin {
  
  final TransferService transferService = TransferService();
  final List<TastescoreModel> _scores = [];

  final UserModel? owner = AuthHelper.user;
  AccountService() {
    getUserScore(owner?.id ?? "");
    getTransfers(owner?.id ?? "");
    // getUsersScoreList();
  }

  List<TastescoreModel> get scores =>
      _scores..sort((b, a) => a.timestamp == null || b.timestamp == null ? 0 : a.timestamp!.difference(b.timestamp!).inSeconds);
  final UserService userService = UserService();

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

  int userRankIndex = 0;

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


  Future<void> getUsersScoreList() async {
    try {
      var scores = await tastScoreService.getScoreList();
      var newMap = groupBy(scores, (obj) => obj.userId);
      for (var key in newMap.keys) {
        if (key != null) {
          var score = UserScoreModel(id: key, scores: newMap[key] ?? []);
          
          _usersScoreList.add(score);
        }
      }
      for (int i = 0; i < userTotalScores.length; i++) {
        if (userTotalScores[i].id == owner!.id) {
          userRankIndex = i + 1;
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
    } finally {
      notifyListeners();
    }
  }
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<bool> removeGalleries(List<String> images, UserModel user) async {
    try {
      final userDoc = await _firestore.collection('users2').doc(user.id).get();
      
      if (!userDoc.exists) {
        throw Exception('User not found');
      }

      final userData = userDoc.data();
      final galleries = List<Map<String, dynamic>>.from(userData?['galleries'] ?? []);
      logger.d("db galleries are $galleries");
      // Find all galleries that match the media strings
      final updatedGalleries = galleries
        .map((gallery) {
          if (images.contains(gallery["media"])) {
            gallery["deleted_at"] = DateTime.now();
            gallery["status"] = "deleted";
          }
          return gallery;
        })
        .toList();

      if (updatedGalleries.isEmpty) {
        throw Exception('No matching galleries found');
      }

      // Remove all matching galleries in one operation
      await _firestore.collection('users2').doc(user.id).update({
        'galleries': updatedGalleries
      });

      return true;
    } catch (e) {
      logger.e("An error occurred while removing user galleries $e");
      return false;
    } finally {
      notifyListeners();
    }
  }
  Future<bool> removeStories(List<String> docIds, UserModel user) async {
    logger.d("Doc ids are $docIds");
    if(docIds.isEmpty) return false;
    try {
      final batch = _firestore.batch();
      for (final docId in docIds) {
        final docRef = _firestore.collection('stories').doc(docId);
        final currentTime = DateTime.now();
        batch.update(docRef, {'deleted_at': currentTime, 'updated_at': currentTime, 'status': 'deleted'});
      }
      await batch.commit();
      return true;
    } catch (e) {
      logger.e("An error occurred while removing user stories $e");
      return false;
    } finally {
      notifyListeners();
    }
  }

}
