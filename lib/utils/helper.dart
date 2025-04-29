import 'dart:io';

import 'package:flutter/material.dart';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';

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
    style: {
      'body': Style(margin: Margins.all(0), padding: HtmlPaddings.all(0)),
      'p': Style(
        margin: Margins.all(0),
        fontSize: fontSize ?? FontSize(16.0),
        fontWeight: FontWeight.w400,
        letterSpacing: -0.3,
      ),
      'a': Style(
        fontSize: fontSize ?? FontSize(16.0),
        fontWeight: FontWeight.w400,
        letterSpacing: -0.3,
      ),
    },
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

  static Future<void> shareStory(
    BuildContext context, {
    required StoryModel story,
  }) async {
    var result = await showModalBottomSheet<int>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Container(
            width: double.infinity,
            color: AppSettingHelper.background,
            padding: const EdgeInsets.symmetric(
              horizontal: 18.0,
              vertical: 24.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () => Navigator.of(context).pop(0),
                  child: Text(
                    'Share To InSoBlok',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                const SizedBox(height: 24.0),
                InkWell(
                  onTap: () => Navigator.of(context).pop(1),
                  child: Text(
                    'Share To Others',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    if (result == 0) {
      shareStoryToInSoBlok(story: story);
    }
    if (result == 1) {
      shareStoryToSocial(story: story);
    }
  }

  static Future<ShareResult> shareStoryToSocial({
    required StoryModel story,
  }) async {
    var result = await SharePlus.instance.share(
      ShareParams(text: story.text, title: story.title),
    );
    logger.d(result);
    return result;
  }

  static Future<void> shareStoryToInSoBlok({required StoryModel story}) async {
    Fluttertoast.showToast(
      msg: 'This feature was not added yet! Will be came soon. ',
    );
  }

  static Future<void> shareComment({required StoryCommentModel comment}) async {
    Fluttertoast.showToast(
      msg: 'This feature was not added yet! Will be came soon. ',
    );
  }
}
