import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class TastescoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference<Map<String, dynamic>> get tastescoreCollection =>
      _firestore.collection('tastescore');

  Future<int> loginScore(UserModel user) async {
    try {
      var reward = user.rewardDate ?? 0;
      var loginedDate = user.updateDate ?? DateTime.now();
      logger.d(kDateYMDFormatter.format(user.updateDate!));

      var logined = DateTime(
        loginedDate.year,
        loginedDate.month,
        loginedDate.day,
      );
      var current = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      );

      var rewardValue = 0;

      if (current.difference(logined) == Duration(days: 1)) {
        reward = reward + 1;
        var bonus = reward ~/ 3;
        rewardValue =
            AppSettingHelper.appSettingModel!.xpEarn![5].reward! + 5 * bonus;
      } else if (current.difference(logined) > Duration(days: 1)) {
        reward = 0;

        rewardValue = AppSettingHelper.appSettingModel!.xpEarn![5].reward!;
      }

      if (rewardValue > 0) {
        var tastescore = TastescoreModelExt.creatXpModel(
          rewardValue,
          user.uid!,
        );
        await tastescoreCollection.add(tastescore.toMap());
      }

      return reward;
    } catch (e) {
      logger.e(e);
    }
    return 0;
  }

  Future<void> winCreatorScore() async {
    var tastescore = TastescoreModelExt.creatXpModel(
      AppSettingHelper.appSettingModel!.xpEarn![4].reward!,
      AuthHelper.user!.uid!,
      type: TastescoreType.WINCREATOR,
    );
    await tastescoreCollection.add(tastescore.toMap());
  }

  Future<List<TastescoreModel>> getScoreList() async {
    List<TastescoreModel> scoreList = [];
    var scoreSnapshot = await tastescoreCollection.get();
    for (var doc in scoreSnapshot.docs) {
      try {
        var json = doc.data();
        json['id'] = doc.id;
        var score = TastescoreModel.fromJson(json);
        if (score.uid != null) {
          scoreList.add(score);
        }
      } on FirebaseException catch (e) {
        logger.e(e.message);
      }
    }
    return scoreList;
  }

  Future<List<TastescoreModel>> getScoresByUser(String uid) async {
    List<TastescoreModel> scoreList = [];
    var scoreSnapshot =
        await tastescoreCollection.where('uid', isEqualTo: uid).get();
    for (var doc in scoreSnapshot.docs) {
      try {
        var json = doc.data();
        json['id'] = doc.id;
        var score = TastescoreModel.fromJson(json);
        if (score.uid != null) {
          scoreList.add(score);
        }
      } on FirebaseException catch (e) {
        logger.e(e.message);
      }
    }
    logger.d(scoreList.length);
    return scoreList;
  }
}
