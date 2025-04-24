import 'dart:io';

import 'package:flutter/material.dart';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:insoblok/services/services.dart';
import 'package:url_launcher/url_launcher.dart';

class AIHelpers {
  static Future<String> getDeviceIdentifier() async {
    String deviceIdentifier = "unknown";
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceIdentifier = androidInfo.id;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceIdentifier = iosInfo.identifierForVendor ?? 'unknown';
    }
    return deviceIdentifier;
  }

  static Widget htmlRender(String? data, {FontSize? fontSize}) => Html(
    data: data,
    shrinkWrap: true,
    style: {'p': Style(fontSize: fontSize ?? FontSize.large)},
    onLinkTap: (url, attributes, element) {
      logger.d(url);
      if (url != null) {
        loadUrl(url);
      }
    },
    onAnchorTap: (url, attributes, element) {
      logger.d(url);
      if (url != null) {
        loadUrl(url);
      }
    },
  );

  static Future<bool> loadUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      return await launchUrl(Uri.parse(url));
    }
    return false;
  }
}
