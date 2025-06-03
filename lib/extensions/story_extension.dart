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
}
