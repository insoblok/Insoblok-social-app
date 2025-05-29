import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';

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
        fontSize: fontSize ?? FontSize(14.0),
        fontWeight: FontWeight.w400,
        letterSpacing: -0.3,
      ),
      'a': Style(
        fontSize: fontSize ?? FontSize(14.0),
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
    AIHelpers.showToast(
      msg: 'This feature was not added yet! Will be came soon. ',
    );
  }

  static Future<void> shareComment({required StoryCommentModel comment}) async {
    AIHelpers.showToast(
      msg: 'This feature was not added yet! Will be came soon. ',
    );
  }

  static Future<void> sendEmail({
    required String subject,
    required String body,
  }) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: kRecevierEmail,
      queryParameters: {'subject': subject, 'body': body},
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      throw 'Could not launch email';
    }
  }

  static Future<void> shareFileToSocial(String path) async {
    final params = ShareParams(text: 'Share Meida', files: [XFile(path)]);

    final result = await SharePlus.instance.share(params);

    if (result.status == ShareResultStatus.success) {
      AIHelpers.showToast(msg: 'Thank you for sharing the media!');
    }
  }

  static Future<void> goToDetailView(
    BuildContext context,
    List<String> medias,
  ) async {
    Routers.goToMediaDetailPage(context, medias: medias);
  }

  static Future<String?> goToDescriptionView(
    BuildContext context, {
    List<Map<String, dynamic>>? quillData,
  }) async {
    var desc = await Routers.goToQuillDescriptionPage(
      context,
      origin: jsonEncode(quillData),
    );
    final converter = QuillDeltaToHtmlConverter(
      desc,
      ConverterOptions.forEmail(),
    );
    return converter.convert();
  }

  static Future<bool?> showToast({required String msg}) {
    return Fluttertoast.showToast(msg: msg);
  }
}
