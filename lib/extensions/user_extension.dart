import 'package:flutter/material.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

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
    var f = (firstName ?? '--').trim();
    var l = (lastName ?? '--').trim();
    return '${f[0].toUpperCase()}${f.substring(1)} ${l[0].toUpperCase()}${l.substring(1)}';
  }

  Widget avatarStatusView({double? width, double? height}) {
    return ClipOval(
      child: AIImage(avatar, width: width ?? 60.0, height: height ?? 60.0),
    );
  }

  String get sinceStr {
    return kDateMMMMYYFormatter.format(
      regdate != null ? regdate! : DateTime.now(),
    );
  }

  List<Map<String, String>> get linkInfo => [
    if (website != null)
      {'type': 'website', 'title': website!, 'icon': AIImages.icLink},
    {'type': 'since', 'title': 'Joined $sinceStr', 'icon': AIImages.icCalendar},
    {'type': 'location', 'title': 'United State', 'icon': AIImages.icLocation},
  ];
}
