import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

extension StoryModelExt on StoryModel {
  bool isLike() {
    var like = likes ?? [];
    return like.contains(AuthHelper.user!.uid);
  }

  bool isFollow() {
    var follow = follows ?? [];
    return follow.contains(AuthHelper.user!.uid);
  }

  String get shownDate {
    return kDateMDYFormatter.format(
      regdate != null ? regdate! : DateTime.now(),
    );
  }

  String get shownHMDate {
    return kDateHMMDYFormatter.format(
      regdate != null ? regdate! : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'title': title,
      'text': text,
      'status': status,
      'likes': likes,
      'follows': follows,
      'medias': (medias ?? []).map((e) => e.toJson()).toList(),
      'comments': (comments ?? []).map((e) => e.toMap()).toList(),
    };
  }
}

extension StoryCommentExt on StoryCommentModel {
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'content': content,
      'medias': (medias ?? []).map((e) => e.toJson()).toList(),
    };
  }
}
