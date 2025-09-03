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
      
      var reward = UserXPValue.loginXP;

      var tastescore = TastescoreModelExt.creatXpModel(
        reward,
        user.id!,
        type: TastescoreType.LOGIN,
      );
      await tastescoreCollection.add(tastescore.toMap());

      return reward;
    } catch (e) {
      logger.e(e);
    }
    return 0;
  }

  Future<void> registerScore(int score) async {

    var reward = UserXPValue.reactionXP;

    var tastescore = TastescoreModelExt.creatXpModel(
      reward,
      AuthHelper.user!.id!,
      type: TastescoreType.REGISTER,
    );
    await tastescoreCollection.add(tastescore.toMap());
  }

  Future<void> voteScore(StoryModel story) async {

    var reward = UserXPValue.voteXP;

    var tastescore = TastescoreModelExt.creatXpModel(
      reward,
      AuthHelper.user!.id!,
      type: TastescoreType.VOTE,
    );
    await tastescoreCollection.add(tastescore.toMap());

    if(AuthHelper.user!.id! != story.userId!){
      var tastescoretoonwer = TastescoreModelExt.creatXpModel(
        reward,
        story.userId!,
        type: TastescoreType.VOTE,
      );
      await tastescoreCollection.add(tastescoretoonwer.toMap());
    }
    
  }

  Future<void> postScore() async {

    var reward = UserXPValue.postXP;

    var tastescore = TastescoreModelExt.creatXpModel(
      reward,
      AuthHelper.user!.id!,
      type: TastescoreType.POST,
    );
    await tastescoreCollection.add(tastescore.toMap());
  }

  Future<void> repostScore(StoryModel story) async {
    var reward = UserXPValue.postXP;

    var tastescore = TastescoreModelExt.creatXpModel(
      reward,
      AuthHelper.user!.id!,
      type: TastescoreType.REPOST,
    );
    await tastescoreCollection.add(tastescore.toMap());

    // var tastescorereposted = TastescoreModelExt.creatXpModel(
    //   reward,
    //   story.userId!,
    //   type: TastescoreType.REPOSTED,
    // );
    // await tastescoreCollection.add(tastescorereposted.toMap());
  }

  Future<void> remixScore() async {

    var reward = UserXPValue.remixXP;

    var tastescore = TastescoreModelExt.creatXpModel(
      reward,
      AuthHelper.user!.id!,
      type: TastescoreType.REMIX,
    );
    await tastescoreCollection.add(tastescore.toMap());
  }

  Future<void> commentScore() async {

    var reward = UserXPValue.commentXP;

    var tastescore = TastescoreModelExt.creatXpModel(
      reward,
      AuthHelper.user!.id!,
      type: TastescoreType.COMMENT,
    );
    await tastescoreCollection.add(tastescore.toMap());
  }

  Future<void> replyScore() async {

    var reward = UserXPValue.replyXP;

    var tastescore = TastescoreModelExt.creatXpModel(
      reward,
      AuthHelper.user!.id!,
      type: TastescoreType.REPLY,
    );
    await tastescoreCollection.add(tastescore.toMap());
  }

  Future<void> followScore() async {

    var reward = UserXPValue.followXP;

    var tastescore = TastescoreModelExt.creatXpModel(
      reward,
      AuthHelper.user!.id!,
      type: TastescoreType.FOLLOW_UNFOLLOW,
    );
    await tastescoreCollection.add(tastescore.toMap());
  }

  Future<void> taggingScore() async {

    var reward = UserXPValue.taggingXP;

    var tastescore = TastescoreModelExt.creatXpModel(
      reward,
      AuthHelper.user!.id!,
      type: TastescoreType.TAGGING,
    );
    await tastescoreCollection.add(tastescore.toMap());
  }

  Future<void> mentionScore() async {

    var reward = UserXPValue.mentionXP;

    var tastescore = TastescoreModelExt.creatXpModel(
      reward,
      AuthHelper.user!.id!,
      type: TastescoreType.MENTIONS,
    );
    await tastescoreCollection.add(tastescore.toMap());
  }

  Future<void> shareOutsideScore() async {

    var reward = UserXPValue.shareOutsideXP;

    var tastescore = TastescoreModelExt.creatXpModel(
      reward,
      AuthHelper.user!.id!,
      type: TastescoreType.SHARE_OUTSIDE,
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
