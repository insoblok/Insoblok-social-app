import 'package:insoblok/models/models.dart';

class TastescoreType {
  static String VOTE = 'vote';
  static String REPOST = 'repost';
  static String REMIX = 'remix';
  static String FREESTYLE = 'post_freestyle';
  static String WINCREATOR = 'win_creator';
  static String LOGIN = 'daily_bonus';

  static String BONUS = 'bonus';
}

extension TastescoreModelExt on TastescoreModel {
  Map<String, dynamic> toMap() {
    Map<String, dynamic> result = {
      'uid': uid,
      'post_id': postId,
      'user_uid': userUid,
      'type': type,
      'bonus': bonus,
      'desc': desc,
      'update_date': updateDate?.toUtc().toIso8601String(),
      'timestamp': timestamp?.toUtc().toIso8601String(),
    };
    result.removeWhere((k, v) => v == null);
    return result;
  }

  static TastescoreModel creatXpModel(
    int xp,
    String uid, {
    String? userUid,
    String type = 'daily_bonus',
    String? postId,
  }) {
    return TastescoreModel(
      uid: uid,
      postId: postId,
      userUid: userUid,
      type: type,
      bonus: xp,
      updateDate: DateTime.now(),
      timestamp: DateTime.now(),
    );
  }
}
