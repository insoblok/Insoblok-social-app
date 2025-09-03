import 'package:insoblok/models/models.dart';

class TastescoreType {

  static String LOGIN = 'daily_bonus';
  static String REGISTER = 'register';
  static String VOTE = 'vote';
  static String POST = 'post';
  static String REPOST = 'repost';
  static String REPOSTED = 'reposted';
  static String REMIX = 'remix';
  static String REACTION = 'reaction';
  static String REACTED = 'reacted';
  static String COMMENT = 'comment';
  static String REPLY = 'reply';
  static String FOLLOW_UNFOLLOW = 'follow/unfollow';
  static String TAGGING = 'tagging';
  static String MENTIONS = 'mentions';
  static String SHARE_OUTSIDE = 'share_outside';
  
  static String FREESTYLE = 'post_freestyle';
  static String WINCREATOR = 'win_creator';
  static String BONUS = 'bonus';
}

final kScoreDescription = {

  TastescoreType.LOGIN: 'Daily Bouns',
  TastescoreType.REGISTER: 'Welcome to InSoBlok',
  TastescoreType.VOTE: 'Voted to a story',
  TastescoreType.POST: 'Posted a story',
  TastescoreType.REPOST: 'Reposted a story',
  TastescoreType.REPOSTED: 'Someone reposted your story',
  TastescoreType.REMIX: 'Remixed a story',
  TastescoreType.COMMENT: 'Commented to a story',
  TastescoreType.REPLY: 'Replied',
  TastescoreType.FOLLOW_UNFOLLOW: 'Followed/Unfollowed a story',
  TastescoreType.TAGGING: 'Tagged a story',
  TastescoreType.MENTIONS: 'Mentioned a story',
  TastescoreType.SHARE_OUTSIDE: 'Shared a story outside',

  TastescoreType.FREESTYLE: 'You have received 100 votes from InSoBlok',
  TastescoreType.WINCREATOR: 'Welcome to create a voted story',
  
  'login': 'Welcome to InSoBlok',
  '${TastescoreType.REPOST}-${TastescoreType.BONUS}':
      'Someone have given a vote to your fork story.',
  '${TastescoreType.FREESTYLE}-${TastescoreType.BONUS}':
      'You have got a freestyle bonus.',
};

extension TastescoreModelExt on TastescoreModel {
  Map<String, dynamic> toMap() {
    Map<String, dynamic> result = {
      'user_id': userId,
      'post_id': postId,
      'post_user_id': postUserId,
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
    String userId, {
    String? postUserId,
    String type = 'daily_bonus',
    String? postId,
  }) {
    return TastescoreModel(
      userId: userId,
      postId: postId,
      postUserId: postUserId,
      type: type,
      bonus: xp,
      updateDate: DateTime.now(),
      timestamp: DateTime.now(),
    );
  }
}
