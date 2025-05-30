import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

var kAvatarColors = [
  AIColors.blue,
  AIColors.pink,
  AIColors.yellow,
  AIColors.green,
  AIColors.grey,
  AIColors.black,
  AIColors.purple,
  AIColors.red,
];

extension UserModelExt on UserModel {
  bool isLike() {
    var like = likes ?? [];
    return like.contains(AuthHelper.user!.uid);
  }

  bool isFollow() {
    var follow = follows ?? [];
    return follow.contains(AuthHelper.user!.uid);
  }

  String get fullName {
    try {
      if (lastName?.isEmpty ?? true) {
        var f = (firstName ?? '--').trim();
        return '${f[0].toUpperCase()}${f.substring(1)}';
      }
      var f = (firstName ?? '--').trim();
      var l = (lastName ?? '--').trim();
      return '${f[0].toUpperCase()}${f.substring(1)} ${l[0].toUpperCase()}${l.substring(1)}';
    } catch (e) {
      return firstName ?? '';
    }
  }

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

  Widget avatarStatusView({
    double? width,
    double? height,
    double? borderWidth,
    double? textSize,
    double? statusSize,
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
              borderRadius: BorderRadius.circular(30.0),
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
                                ? AIColors.pink
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
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              decoration: BoxDecoration(
                color: AIColors.white,
                shape: BoxShape.circle,
              ),
              child: AIImage(
                Icons.brightness_1,
                color: status == 'Online' ? AIColors.green : AIColors.lightGrey,
                width: statusSize ?? 14.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String get sinceStr {
    return kDateMMMMYYFormatter.format(
      regdate != null ? regdate! : DateTime.now(),
    );
  }

  List<Map<String, dynamic>> get linkInfo => [
    if (website != null)
      {'type': 'website', 'title': website!, 'icon': AIImages.icLink},
    {'type': 'since', 'title': 'Joined $sinceStr', 'icon': AIImages.icCalendar},
    {'type': 'location', 'title': 'United State', 'icon': AIImages.icLocation},
    {'type': 'wallet', 'title': 'My Wallet', 'icon': Icons.wallet},
  ];

  Map<String, dynamic> toMap() {
    return {
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
      'likes': likes,
      'follows': follows,
      'actions': (actions ?? []).map((e) => e.toJson()).toList(),
    };
  }
}
