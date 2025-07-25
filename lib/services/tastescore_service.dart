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

      logger.d(current.difference(logined).inSeconds);

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
        var tastescore = TastescoreModelExt.creatXpModel(rewardValue, user.id!);
        await tastescoreCollection.add(tastescore.toMap());
      }

      return reward;
    } catch (e) {
      logger.e(e);
    }
    return 0;
  }

  Future<void> registerScore(int score) async {
    var tastescore = TastescoreModelExt.creatXpModel(
      score,
      AuthHelper.user!.id!,
      type: TastescoreType.REGISTER,
    );
    await tastescoreCollection.add(tastescore.toMap());
  }

  Future<void> winCreatorScore() async {
    var tastescore = TastescoreModelExt.creatXpModel(
      AppSettingHelper.appSettingModel!.xpEarn![4].reward!,
      AuthHelper.user!.id!,
      type: TastescoreType.WINCREATOR,
    );
    await tastescoreCollection.add(tastescore.toMap());
  }

  Future<void> voteScore(StoryModel story) async {
    var scores = await getScoresByUser(story.userId!);
    var contained = false;
    for (var score in scores) {
      if (score.postId == story.id &&
          score.userId == AuthHelper.user?.id &&
          score.type != TastescoreType.VOTE) {
        contained = true;
        break;
      }
    }
    if (!contained) {
      var userService = UserService();
      var owner = await userService.getUser(story.id!);
      var rewardVote =
          (AppSettingHelper.appSettingModel?.xpEarn?[0].reward ?? 0);
      if (owner?.freeStyle == true) {
        rewardVote =
            (rewardVote *
                    (AppSettingHelper.appSettingModel?.xpEarn?[3].bonus ?? 0.0))
                .toInt();
      }
      var scoreVote = TastescoreModelExt.creatXpModel(
        rewardVote,
        story.userId!,
        postUserId: AuthHelper.user?.id,
        postId: story.id,
        type:
            (owner?.freeStyle == true)
                ? '${TastescoreType.FREESTYLE}-${TastescoreType.BONUS}'
                : TastescoreType.VOTE,
      );
      await tastescoreCollection.add(scoreVote.toMap());

      if (scores.length == 99) {
        await userService.updateUser(owner!.copyWith(freeStyle: true));
        var rewardFreeStyle =
            (AppSettingHelper.appSettingModel?.xpEarn?[3].reward ?? 0);
        var scoreFreeStyle = TastescoreModelExt.creatXpModel(
          rewardFreeStyle,
          story.userId!,
          type: TastescoreType.FREESTYLE,
        );
        await tastescoreCollection.add(scoreFreeStyle.toMap());
      }

      for (ConnectedStoryModel connect in (story.connects ?? [])) {
        var rewardRepost =
            ((AppSettingHelper.appSettingModel?.xpEarn?[0].reward ?? 0) *
                    (AppSettingHelper.appSettingModel?.xpEarn?[1].bonus ?? 0.0))
                .toInt();
        var scoreRepost = TastescoreModelExt.creatXpModel(
          rewardRepost,
          connect.userId!,
          postUserId: AuthHelper.user?.id,
          postId: connect.postId,
          type: '${TastescoreType.REPOST}-${TastescoreType.BONUS}',
        );
        await tastescoreCollection.add(scoreRepost.toMap());
      }
    }
  }

  Future<void> repostScore(StoryModel story) async {
    var rewardRepost =
        (AppSettingHelper.appSettingModel?.xpEarn?[1].reward ?? 0);
    var scoreRepost = TastescoreModelExt.creatXpModel(
      rewardRepost,
      story.userId!,
      postUserId: AuthHelper.user?.id,
      postId: story.id,
      type: TastescoreType.REPOST,
    );
    await tastescoreCollection.add(scoreRepost.toMap());

    for (ConnectedStoryModel connect in (story.connects ?? [])) {
      var scoreConnect = TastescoreModelExt.creatXpModel(
        rewardRepost,
        connect.userId!,
        postUserId: AuthHelper.user?.id,
        postId: connect.postId,
        type: TastescoreType.REPOST,
      );
      await tastescoreCollection.add(scoreConnect.toMap());
    }
  }

  Future<List<TastescoreModel>> getScoreList() async {
    List<TastescoreModel> scoreList = [];
    var scoreSnapshot = await tastescoreCollection.get();
    for (var doc in scoreSnapshot.docs) {
      try {
        var json = doc.data();
        json['id'] = doc.id;
        var score = TastescoreModel.fromJson(json);
        if (score.userId != null) {
          scoreList.add(score);
        }
      } on FirebaseException catch (e) {
        logger.e(e.message);
      }
    }
    return scoreList;
  }

  Future<List<TastescoreModel>> getScoresByUser(String id) async {
    List<TastescoreModel> scoreList = [];
    var scoreSnapshot =
        await tastescoreCollection.where('user_id', isEqualTo: id).get();
    for (var doc in scoreSnapshot.docs) {
      try {
        var json = doc.data();
        json['id'] = doc.id;
        var score = TastescoreModel.fromJson(json);
        if (score.userId != null) {
          scoreList.add(score);
        }
      } on FirebaseException catch (e) {
        logger.e(e.message);
      }
    }
    logger.d(scoreList.length);
    return scoreList;
  }

  Future<List<TastescoreModel>> getScoresByStory(StoryModel story) async {
    List<TastescoreModel> scoreList = [];
    var scoreSnapshot =
        await tastescoreCollection
            .where('user_id', isEqualTo: story.userId)
            .where('post_id', isEqualTo: story.id)
            .get();
    for (var doc in scoreSnapshot.docs) {
      try {
        var json = doc.data();
        json['id'] = doc.id;
        var score = TastescoreModel.fromJson(json);
        if (score.userId != null) {
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
