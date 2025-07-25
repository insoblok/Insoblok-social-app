import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

extension StoryModelExt on StoryModel {
  bool? isVote() {
    try {
      var vs = votes ?? [];
      var vote = vs.firstWhere((v) => v.userId == AuthHelper.user!.id);

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

  int get cntLooksToday {
    var vs = votes ?? [];
    int cnt =
        vs.where((v) => v.timestamp!.day == DateTime.now().day).toList().length;
    return cnt > 5 ? 5 : cnt;
  }

  bool isLike() {
    var like = likes ?? [];
    return like.contains(AuthHelper.user!.id);
  }

  bool isFollow() {
    var follow = follows ?? [];
    return follow.contains(AuthHelper.user!.id);
  }

  bool isView() {
    var view = views ?? [];
    return view.contains(AuthHelper.user!.id);
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
      'user_id': userId,
      'title': title,
      'text': text,
      'status': status,
      'category': category,
      'likes': (likes),
      'follows': (follows),
      'views': (views),
      'update_date': updateDate?.toUtc().toIso8601String(),
      'timestamp': timestamp?.toUtc().toIso8601String(),
      'connects': ((connects ?? []).map((e) => e.toMap()).toList()),
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
      'user_id': userId,
      'vote': vote,
      'timestamp': timestamp?.toUtc().toIso8601String(),
    };
    result.removeWhere((k, v) => v == null);
    return result;
  }
}

extension MediaStoryModelExt on MediaStoryModel {
  Map<String, dynamic> toMap() {
    Map<String, dynamic> result = {
      'link': link,
      'type': type,
      'width': width,
      'height': height,
    };
    result.removeWhere((k, v) => v == null);
    return result;
  }
}

extension StoryCommentModelExt on StoryCommentModel {
  Map<String, dynamic> toMap() {
    Map<String, dynamic> result = {
      'user_id': userId,
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

extension ConnectedStoryModelExt on ConnectedStoryModel {
  Map<String, dynamic> toMap() {
    Map<String, dynamic> result = {'post_id': postId, 'user_id': userId};
    result.removeWhere((k, v) => v == null);
    return result;
  }
}
