import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class FaceDetailProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  late String _url;
  String get url => _url;
  set url(String f) {
    _url = f;
    notifyListeners();
  }

  File? _face;
  File? get face => _face;
  set face(File? f) {
    _face = f;
    notifyListeners();
  }

  StoryModel? _story;
  StoryModel? get story => _story;
  set story(StoryModel? model) {
    _story = model;
    notifyListeners();
  }

  bool _showFaceDialog = true;
  bool get showFaceDialog => _showFaceDialog;
  set showFaceDialog(bool f) {
    _showFaceDialog = f;
    notifyListeners();
  }

  String? _resultFaceUrl;
  String? get resultFaceUrl => _resultFaceUrl;
  set resultFaceUrl(String? s) {
    _resultFaceUrl = s;
    notifyListeners();
  }

  int _pageIndex = 0;
  int get pageIndex => _pageIndex;
  set pageIndex(int i) {
    _pageIndex = i;
    notifyListeners();
  }

  List<AIFaceAnnotation> annotations = [];

  Future<void> init(BuildContext context, {required String url, required File face}) async {
    this.context = context;
    this.url = url;

    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/face_mickle.png';
    this.face = File(filePath);
  }

  Future<void> detectFace(String link) async {
    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        var faces = await GoogleVisionHelper.getFacesFromImage(link: link);
        annotations.clear();
        annotations.addAll(await GoogleVisionHelper.analyzeImage(link: link));

        if (faces.isNotEmpty) {
          final directory = await getApplicationDocumentsDirectory();
          final filePath = '${directory.path}/face.png';
          final file = File(filePath);
          if (!file.existsSync()) {
            await file.create();
          }
          _face = await file.writeAsBytes(img.encodePng(faces[0]));
          notifyListeners();
        }
      } catch (e) {
        logger.e(e);
        setError(e);
      } finally {
        notifyListeners();
      }
    }());
  }

  Future<void> onClickActionButton(int index) async {
    if (isBusy) return;

    logger.d('button index: $index');

    switch (index) {
      case 0:
        await repost();
        break;
      case 1:
        break;
      case 2:
        break;
    }
  }

  Future<void> repost() async {
  if (isBusy) return;
  clearErrors();

  await runBusyFuture(() async {
    try {
      var hasDescription = await _showDescriptionDialog();
      if (hasDescription != true) return;

      final description = await AIHelpers.goToDescriptionView(context);
      if (description == null || description.isEmpty) {
        throw ('empty description!');
      }

      resultFaceUrl = await storyService.uploadResult(
        face!.path,
        folderName: 'face',
      );

      logger.d("resultFaceUrl: $resultFaceUrl");

      MediaStoryModel? media;
      if (resultFaceUrl != null){

        var bytes = await File(face!.path).readAsBytes();
        var decodedImage = img.decodeImage(bytes);

        media = MediaStoryModel(
          link: resultFaceUrl,
          type: 'image',
          width: decodedImage?.width.toDouble(),
          height: decodedImage?.height.toDouble(),
        );
      }

      var newStory = StoryModel(
        title: 'Repost',
        text: description,
        status: 'private',
        category: 'vote',
        medias: media != null ? [media] : [],
        updateDate: DateTime.now(),
        timestamp: DateTime.now(),
      );

      await storyService.postStory(story: newStory);

      if (story != null) {
        await tastScoreService.repostScore(story!);
      }

      logger.d("newStory: $newStory");
      AIHelpers.showToast(msg: 'Successfully reposted to LOOKBOOK!');
    } catch (e) {
      setError(e);
      logger.e(e);
    } finally {
      notifyListeners();
    }
  }());

  if (hasError) {
    AIHelpers.showToast(msg: modelError.toString());
  }
}

  Future<bool?> _showDescriptionDialog() => showDialog<bool>(
    context: context,
    builder: (context) {
      return Center(
        child: Container(
          margin: const EdgeInsets.all(40.0),
          padding:
              const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSecondary,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Repost Story',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 16.0),
              Text(
                'Do you want to post this reaction to your LOOKBOOK?',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 24.0),
              Row(
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
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSecondary,
                              ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(false),
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
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: Theme.of(context).primaryColor),
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
}
