import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';

extension TastescoreModelExt on TastescoreModel {
  Map<String, dynamic> toMap() {
    Map<String, dynamic> result = {
      'uid': uid,
      'post_id': postId,
      'user_uid': userUid,
      'type': type,
      'bonus': bonus,
      'desc': desc,
      'connects': ((connects ?? []).map((e) => e.toMap()).toList()),
      'update_date': updateDate?.toUtc().toIso8601String(),
      'timestamp': timestamp?.toUtc().toIso8601String(),
    };
    result.removeWhere((k, v) => v == null);
    return result;
  }

  static TastescoreModel getLoginXp(int xp, String uid) {
    return TastescoreModel(
      uid: uid,
      type: 'login',
      bonus: xp,
      updateDate: DateTime.now(),
      timestamp: DateTime.now(),
    );
  }
}

extension ConnectedStoryModelExt on ConnectedStoryModel {
  Map<String, dynamic> toMap() {
    Map<String, dynamic> result = {'post_id': postId, 'user_uid': userUid};
    result.removeWhere((k, v) => v == null);
    return result;
  }
}
