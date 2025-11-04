import 'dart:io';

import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/routers/router.dart';

class AvatarProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  String result = "";

  bool isSaving = false;

  Future<void> init(BuildContext context, String? src, String? dst) async {
    this.context = context;
    ratioIndex = 0;
    if (src != null) result = src;
  }

  int? _ratioIndex;
  int? get ratioIndex => _ratioIndex;
  set ratioIndex(int? i) {
    _ratioIndex = i;
    notifyListeners();
  }

  String? _prompt;
  String? get prompt => _prompt;
  set prompt(String? s) {
    _prompt = s;
    notifyListeners();
  }

  String? _originPath;
  String? get originPath => _originPath;
  set originPath(String? s) {
    _originPath = s;
    notifyListeners();
  }

  File? get originFile => originPath == null ? null : File(originPath!);

  final _avatarService = AvatarService();

  Future<void> onImagePicker() async {
    if (ratioIndex == null) {
      Fluttertoast.showToast(
        msg: 'Should be set aspect ratio before choose image',
      );
      return;
    }
    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        var result = await _avatarService.pickCropImage(context, ratioIndex!);
        if (result != null) {
          originPath = result;
        }
      } catch (e) {
        setError(e);
        logger.e(e);
      } finally {
        notifyListeners();
      }
    }());

    if (hasError) {
      Fluttertoast.showToast(msg: modelError.toString());
    }
  }

  String? _pageStatus;
  String? get pageStatus => _pageStatus;
  set pageStatus(String? s) {
    _pageStatus = s;
    notifyListeners();
  }

  String? _originUrl;
  String? get originUrl => _originUrl;
  set originUrl(String? s) {
    _originUrl = s;
    notifyListeners();
  }

  String? _resultFirebaseUrl;
  String? get resultFirebaseUrl => _resultFirebaseUrl;
  set resultFirebaseUrl(String? s) {
    _resultFirebaseUrl = s;
    notifyListeners();
  }

  bool get hasResult => resultFirebaseUrl?.isNotEmpty ?? false;

  void onConvert() {
    if (originPath == null) {
      Fluttertoast.showToast(msg: 'Please choose an origin image first');
      return;
    }
    Routers.goToRRCAvatarGenerationPage(context, originFile, "", "profile", "");
  }

  Future<void> handleTapSave() async {
    if (isSaving) return;

    File? fileToUpload;

    // If result is empty, use originFile (must be not empty)
    if (result.isEmpty) {
      if (originFile == null || originPath == null || originPath!.isEmpty) {
        AIHelpers.showToast(msg: "Please select target avatar media.");
        return;
      }
      fileToUpload = originFile;
      result = originPath!; // Set result to originPath for consistency
    } else {
      fileToUpload = File(result);
    }

    clearErrors();

    isSaving = true;
    runBusyFuture(() async {
      try {
        originUrl = await _avatarService.uploadOriginAvatar(fileToUpload!);
        logger.d("Result is $originUrl, $result");
        if (originUrl == null) throw ('Server error!');

        /*
        // pageStatus = 'Sending an origin image to ai service';
        var taskId = await _avatarService.createTask(
          fileUrl: originUrl!,
          prompt: prompt,
          size: kAvatarAspectRatio[ratioIndex!]['size'] as String,
        );
        if (taskId == null) throw ('AI service error!');
        var aiResult = await _avatarService.setOnProgressListener(
          taskId,
          onProgressListener: (progress) {
            // pageStatus =
            //     'Generating... ${(double.parse(progress) * 100).toInt()}%...';
          },
        );
        if (aiResult['status'] != 'SUCCESS') throw (aiResult['status']);

        // pageStatus = 'Downloading a result image from ai service';
        String aiUrl = (aiResult['response']['resultUrls'] as List).first;
        var resultUrl = await _avatarService.downloadAvatar(taskId, url: aiUrl);
        if (resultUrl == null) throw ('AI service error!');

        // pageStatus = 'Almost done!';
        resultFirebaseUrl = await _avatarService.uploadResultAvatar(resultUrl);
        */
        await AuthHelper.updateUser(user!.copyWith(avatar: originUrl));
        Fluttertoast.showToast(msg: 'Successfully updated avatar!');
      } catch (e, s) {
        setError(e);
        logger.e(e);
        logger.e(s);
      } finally {
        pageStatus = null;
        isSaving = false;
      }
    }());

    if (hasError) {
      Fluttertoast.showToast(msg: modelError.toString());
    }
  }

  bool _isAddOriginImage = false;
  bool get isAddOriginImage => _isAddOriginImage;
  set isAddOriginImage(bool f) {
    _isAddOriginImage = f;
    notifyListeners();
  }

  Future<void> postLookbook() async {
    if (isBusy) return;
    clearErrors();

    try {
      pageStatus = 'Saving to LOOKBOOK...';

      var hasDescription = await _showDescriptionDialog();
      String? description;
      if (hasDescription == true) {
        description = await AIHelpers.goToDescriptionView(context);
      }

      var story = StoryModel(
        title: 'AI Avatar',
        text: description ?? prompt,
        category: 'vote',
        status: 'private',
        medias: [
          MediaStoryModel(link: originUrl!, type: 'image'),
          MediaStoryModel(link: resultFirebaseUrl, type: 'image'),
        ],
        updatedAt: DateTime.now(),
        createdAt: DateTime.now(),
      );
      await storyService.postStory(story: story);
      AIHelpers.showToast(msg: 'Successfully posted Avatar to LOOKBOOK!');

      Navigator.of(context).pop(resultFirebaseUrl);
    } catch (e, s) {
      setError(e);
      logger.e(e);
      logger.e(s);
    } finally {
      pageStatus = null;
    }

    if (hasError) {
      Fluttertoast.showToast(msg: modelError.toString());
    }
  }

  Future<bool?> _showDescriptionDialog() => showDialog<bool>(
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
                'Do you just want to add a description for LOOKBOOK post?',
                style: Theme.of(context).textTheme.labelMedium,
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
                            color: Colors.white,
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

  void handleTapAvatars(String? path) {
    result = path!;
    notifyListeners();
  }
}
