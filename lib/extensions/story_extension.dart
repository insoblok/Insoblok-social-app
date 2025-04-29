import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

extension StoryModelExt on StoryModel {
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'title': title,
      'text': text,
      'regdate': regdate,
      'status': status,
      'timestamp': timestamp,
      'likes': likes,
      'follows': follows,
      'medias': (medias ?? []).map((e) => e.toJson()).toList(),
      'comments': (comments ?? []).map((e) => e.toJson()).toList(),
    };
  }

  bool isLike() {
    var like = likes ?? [];
    return like.contains(AuthHelper.user!.uid);
  }

  bool isFollow() {
    var follow = follows ?? [];
    return follow.contains(AuthHelper.user!.uid);
  }

  String get shownDate {
    var date = kFullDateTimeFormatter.parse(regdate!, true);
    return kDateMDYFormatter.format(date.toLocal());
  }

  String get shownHMDate {
    var date = kFullDateTimeFormatter.parse(regdate!, true);
    return kDateHMMDYFormatter.format(date.toLocal());
  }
}

extension StoryCommentModelExt on StoryCommentModel {
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'timestamp': timestamp,
      'medias': (medias ?? []).map((e) => e.toJson()).toList(),
    };
  }
}
