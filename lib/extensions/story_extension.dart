import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

extension StoryModelExt on StoryModel {
  bool? isVote() {
    try {
      var vs = votes ?? [];
      var vote = vs.firstWhere((v) => v.uid == AuthHelper.user!.uid);

      return vote.vote;
    } catch (e) {
      return null;
    }
  }

  int get cntYay {
    var vs = votes ?? [];
    return vs.where((v) => v.vote == true).toList().length;
  }

  int get cntNay {
    var vs = votes ?? [];
    return vs.where((v) => v.vote == false).toList().length;
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
    return kDateMDYFormatter.format(
      timestamp != null ? timestamp! : DateTime.now(),
    );
  }

  String get shownHMDate {
    return kDateHMMDYFormatter.format(
      timestamp != null ? timestamp! : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> result = {
      'uid': uid,
      'title': title,
      'text': text,
      'status': status,
      'category': category,
      'likes': (likes),
      'follows': (follows),
      'update_date': updateDate?.toUtc().toIso8601String(),
      'timestamp': timestamp?.toUtc().toIso8601String(),
      'comments': ((comments ?? []).map((e) => e.toMap()).toList()),
      'votes': ((votes ?? []).map((e) => e.toMap()).toList()),
      'medias': ((medias ?? []).map((e) => e.toMap()).toList()),
    };
    result.removeWhere((k, v) => v == null);
    return result;
  }
}

extension StoryVoteModelExt on StoryVoteModel {
  Map<String, dynamic> toMap() {
    Map<String, dynamic> result = {
      'uid': uid,
      'vote': vote,
      'timestamp': timestamp?.toUtc().toIso8601String(),
    };
    result.removeWhere((k, v) => v == null);
    return result;
  }
}

extension MediaStoryModelExt on MediaStoryModel {
  Map<String, dynamic> toMap() {
    Map<String, dynamic> result = {'link': link, 'type': type};
    result.removeWhere((k, v) => v == null);
    return result;
  }
}

extension StoryCommentModelExt on StoryCommentModel {
  Map<String, dynamic> toMap() {
    Map<String, dynamic> result = {
      'uid': uid,
      'content': content,
      'medias': ((medias ?? []).map((e) => e.toMap()).toList()),
      'timestamp': timestamp?.toUtc().toIso8601String(),
    };
    result.removeWhere((k, v) => v == null);
    return result;
  }
}

extension UpdatedStoryModelExt on UpdatedStoryModel {
  Map<String, dynamic> toMap() {
    Map<String, dynamic> result = {
      'timestamp': timestamp?.toUtc().toIso8601String(),
    };
    result.removeWhere((k, v) => v == null);
    return result;
  }
}
