import 'package:flutter/material.dart';

import 'package:gradient_borders/box_borders/gradient_box_border.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

var kAvatarColors = [
  AIColors.blue,
  AIColors.lightPurple,
  AIColors.pink,
  AIColors.lightRed,
  AIColors.yellow,
  AIColors.green,
  AIColors.lightBlue,
  AIColors.lightPink,
  AIColors.purple,
  AIColors.lightYellow,
  AIColors.red,
  AIColors.lightGreen,
];

List<Color> getGradientColors(int number) {
  List<Color> colors = [];
  if (number > kAvatarColors.length) {
    colors.addAll(kAvatarColors);
  } else {
    for (int i = 0; i < number; i++) {
      colors.add(kAvatarColors[i]);
    }
  }
  return colors;
}

extension UserModelExt on UserModel {
  bool isLike() {
    var like = likes ?? [];
    return like.contains(AuthHelper.user!.id);
  }

  bool isFollow() {
    var follow = follows ?? [];
    return follow.contains(AuthHelper.user!.id);
  }

  String get fullName {
    try {
      if (firstName == null ||
          firstName == '' ||
          lastName == null ||
          lastName == '') {
        var address =
            '${walletAddress!.substring(0, 5)}..${walletAddress!.substring(walletAddress!.length - 4)}';
        return address;
      }
      if (lastName?.isEmpty ?? true) {
        var f = (firstName ?? '--').trim();
        return '${f[0].toUpperCase()}${f.substring(1)}';
      }
      var f = (firstName ?? '--').trim();
      var l = (lastName ?? '--').trim();
      return '${f[0].toUpperCase()}${f.substring(1)} ${l[0].toUpperCase()}${l.substring(1)}';
    } catch (e) {
      return walletAddress ?? 'Temp';
    }
  }

  String? get privateWalletAddress =>
      walletAddress == null
          ? null
          : '${walletAddress!.substring(0, 5)}***${walletAddress!.substring(walletAddress!.length - 4)}';

  Widget avatarStatusView({
    double? width,
    double? height,
    double? borderWidth,
    double? textSize,
    double? statusSize,
    bool showStatus = true,
  }) {
    return SizedBox(
      width: width ?? 60.0,
      height: height ?? 60.0,
      child: Stack(
        children: [
          Container(
            width: width ?? 60,
            height: height ?? 60,
            decoration: BoxDecoration(
              border: GradientBoxBorder(
                gradient: LinearGradient(
                  colors: getGradientColors(fullName.length),
                ),
                width: borderWidth ?? 4,
              ),
              borderRadius: BorderRadius.circular(width ?? 60 / 2),
            ),
            child: ClipOval(
              child:
                  avatar != null
                      ? AIImage(
                        avatar,
                        width: width ?? 60.0,
                        height: height ?? 60.0,
                      )
                      : Container(
                        color:
                            fullName.length > kAvatarColors.length
                                ? kAvatarColors[fullName.length %
                                    kAvatarColors.length]
                                : kAvatarColors[fullName.length - 1],
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            fullName[0],
                            style: TextStyle(
                              fontSize: textSize ?? 14.0,
                              color: AIColors.white,
                            ),
                          ),
                        ),
                      ),
            ),
          ),
          showStatus
              ? Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  decoration: BoxDecoration(
                    border: GradientBoxBorder(
                      gradient: LinearGradient(
                        colors: getGradientColors(fullName.length),
                      ),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(
                      statusSize != null ? statusSize / 2 : 7,
                    ),
                  ),
                  // decoration: BoxDecoration(
                  //   color: AIColors.white,
                  //   shape: BoxShape.circle,
                  // ),
                  child: AIImage(
                    Icons.brightness_1,
                    color:
                        status == 'Online'
                            ? AIColors.green
                            : AIColors.lightGrey,
                    width: statusSize ?? 14.0,
                  ),
                ),
              )
              : Container(),
        ],
      ),
    );
  }

  String get sinceStr {
    return kDateMMMMYYFormatter.format(
      updateDate != null ? updateDate! : DateTime.now(),
    );
  }

  List<Map<String, dynamic>> get linkInfo => [
    if (website != null)
      {'type': 'website', 'title': website!, 'icon': AIImages.icLink},
    {'type': 'since', 'title': '$sinceStr', 'icon': AIImages.icCalendar},
    {
      'type': 'location',
      'title': country ?? 'United State',
      'icon': AIImages.icLocation,
    },
    if (id == AuthHelper.user?.id)
      {'type': 'wallet', 'title': 'My Wallet', 'icon': Icons.wallet},
  ];



  Map<String, dynamic> toMap() {
    Map<String, dynamic> result = {
      'uid': uid,
      'wallet_address': walletAddress,
      'avatar': avatar,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password': password,
      'city': city,
      'country': country,
      'website': website,
      'desc': desc,
      'discovery': discovery,
      'nick_id': nickId,
      'lat': lat,
      'lon': lon,
      'ip_address': ipAddress,
      'status': status,
      'has_vote_post': hasVotePost,
      'free_style': freeStyle,
      'reward_date': rewardDate,
      'transfered_xp': transferedXP,
      'transfered_inso': transferedInSo,
      'favorite_tokens': favoriteTokens,
      'is_premium': isPremium,
      'likes': (likes),
      'follows': (follows),
      'views': (views),
      'user_actions': (userActions),
      'actions': ((actions ?? []).map((e) => e.toMap()).toList()),
      'update_date': updateDate?.toUtc().toIso8601String(),
      'timestamp': timestamp?.toUtc().toIso8601String(),
    };
    result.removeWhere((k, v) => v == null);
    return result;
  }
}

extension UserActionModelExt on UserActionModel {
  Map<String, dynamic> toMap() {
    Map<String, dynamic> result = {
      'post_id': postId,
      'post_user_id': postUserId,
      'value': value,
      'type': type,
      'description': description,
      'timestamp': timestamp?.toUtc().toIso8601String(),
    };
    result.removeWhere((k, v) => v == null);
    return result;
  }
}

extension UserCountryModelExt on UserCountryModel {
  Map<String, dynamic> toMap() {
    return toJson();
  }
}
