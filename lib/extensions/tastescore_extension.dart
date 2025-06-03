import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';

extension TastescoreModelExt on TastescoreModel {
  Map<String, dynamic> toMap() {
    Map<String, dynamic> result = {
      'key': key,
      'post_id': postId,
      'user_uid': userUid,
      'connects': ((connects ?? []).map((e) => e.toMap()).toList()),
      'update_date': updateDate?.toUtc().toIso8601String(),
      'timestamp': timestamp?.toUtc().toIso8601String(),
    };
    result.removeWhere((k, v) => v == null);
    return result;
  }
}

extension ConnectedStoryModelExt on ConnectedStoryModel {
  Map<String, dynamic> toMap() {
    Map<String, dynamic> result = {'post_id': postId, 'user_uid': userUid};
    result.removeWhere((k, v) => v == null);
    return result;
  }
}
