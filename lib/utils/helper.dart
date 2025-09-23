import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';


final _tastScoreService = TastescoreService();
TastescoreService get tastScoreService => _tastScoreService;

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

  static Widget htmlRender(
    String? data, {
    Key? key,
    FontSize? fontSize,
    Color? color,
    TextAlign? textAlign,
  }) => Html(
    key: key,
    data: data ?? '',
    shrinkWrap: true,
    style: {
      'body': Style(margin: Margins.all(0), padding: HtmlPaddings.all(0)),
      'p': Style(
        margin: Margins.all(0),
        fontSize: fontSize ?? FontSize(14.0),
        fontWeight: FontWeight.w400,
        textAlign: textAlign ?? TextAlign.start,
        letterSpacing: -0.3,
        color: color,
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

  static String removeFirstBr(String html) {
    final pattern = RegExp(r'<br\s*/?>', caseSensitive: false);
    return html.replaceFirst(pattern, '');
  }

  static String removeLastBr(String htmlString) {
    final regex = RegExp(r'<br\s*/?>', caseSensitive: false);
    final matches = regex.allMatches(htmlString).toList();

    if (matches.isNotEmpty) {
      final lastMatch = matches.last;
      return htmlString.replaceRange(lastMatch.start, lastMatch.end, '');
    }
    return htmlString;
  }

  static Future<bool> loadUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      return await launchUrl(Uri.parse(url));
    }
    return false;
  }

  static String? extractVimeoId(String url) {
    final regExp = RegExp(
      r'vimeo\.com/(?:channels/.+/|groups/.+/|album/.+/|video/)?(\d+)',
      caseSensitive: false,
    );

    final match = regExp.firstMatch(url);
    if (match != null && match.groupCount >= 1) {
      return match.group(1); // The video ID
    }
    return null; // No match found
  }

  static Future<void> shareStory(
    BuildContext context, {
    required StoryModel story,
  }) async {

    if (story.userId != AuthHelper.user?.id) {
      AIHelpers.showToast(msg: 'You can\'t share this feed.');
      return;
    }

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

    await tastScoreService.shareOutsideScore();
    
    return result;
  }

  static Future<void> shareStoryToInSoBlok({required StoryModel story}) async {

    final usersRef = FirebaseFirestore.instance.collection("user");
      await usersRef.doc(AuthHelper.user?.id).update({
        "status": "public",
      });
    
    AIHelpers.showToast(
      msg: 'This story is shown to everyone of InsoBlok.',
    );
    await tastScoreService.shareOutsideScore();
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
    BuildContext context, {
    required List<String> medias,
    int index = 0,
    String storyID = '',
    String storyUser = '',
  }) async {
    Routers.goToMediaDetailPage(
      context,
      model: MediaDetailModel(medias: medias, index: index, storyID: storyID, storyUser: storyUser),
    );
  }

  static Future<String?> goToDescriptionView(
    BuildContext context, {
    List<Map<String, dynamic>>? quillData,
  }) async {
    var desc = await Routers.goToQuillDescriptionPage(
      context,
      origin: (quillData?.isNotEmpty ?? false) ? jsonEncode(quillData) : null,
    );
    if (desc == null) return null;
    final converter = QuillDeltaToHtmlConverter(
      desc,
      ConverterOptions.forEmail(),
    );
    return converter.convert();
  }

  static Future<bool?> showToast({required String msg}) {
    return Fluttertoast.showToast(msg: msg);
  }

  static Future<bool?> showDescriptionDialog(
    BuildContext context,
  ) => showDialog<bool>(
    context: context,
    builder: (context) {
      return Center(
        child: Container(
          margin: const EdgeInsets.all(40.0),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSecondary,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Add Description',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 16.0),
              Text(
                'Do you just want to add a description for post?',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 24.0),
              Row(
                spacing: 24.0,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(true),
                      child: Container(
                        height: 44.0,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Add',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        height: 44.0,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 2.0,
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Skip',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );

  static String formatDouble(double value, int decimals) {
    return value.toStringAsFixed(decimals).replaceFirst(RegExp(r'\.?0+$'), '');
  }

  static Future<void> launchExternalSource(String uri) async {
    logger.d("Uri is $uri");
    final Uri url = Uri.parse(uri);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static String formatNumbers(double value) {
    return NumberFormat.decimalPattern('en_US').format(value);
  }


  static String formatLargeNumberSmart(num number) {
    final formatter = NumberFormat.decimalPattern();
    if (number >= 1e12) return (number / 1e12).toStringAsFixed(2) + 'T';
    if (number >= 1e9) return (number / 1e9).toStringAsFixed(2) + 'B';
    if (number >= 1e6) return (number / 1e6).toStringAsFixed(2) + 'M';
    if (number >= 1e3) return (number / 1e3).toStringAsFixed(2) + 'K';
    return formatter.format(number); // fallback with commas
  }
}
