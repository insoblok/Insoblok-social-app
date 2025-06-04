import 'package:insoblok/models/models.dart';

class TastescoreType {
  static String LOGIN = 'daily_bonus';
  static String WINCREATOR = 'win_creator';
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
    String type = 'daily_bonus',
  }) {
    return TastescoreModel(
      uid: uid,
      type: type,
      bonus: xp,
      updateDate: DateTime.now(),
      timestamp: DateTime.now(),
    );
  }
}
