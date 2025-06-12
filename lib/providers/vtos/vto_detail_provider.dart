import 'package:flutter/material.dart';

import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class VTODetailPageModel {
  final ProductModel product;
  final String originImage;
  final String resultImage;

  VTODetailPageModel({
    required this.product,
    required this.originImage,
    required this.resultImage,
  });
}

class VTODetailProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  late VTODetailPageModel _model;
  VTODetailPageModel get model => _model;

  final _key = GlobalKey<ExpandableFabState>();
  GlobalKey<ExpandableFabState> get key => _key;

  Future<void> init(
    BuildContext context, {
    required VTODetailPageModel model,
  }) async {
    this.context = context;

    _model = model;
  }

  bool _isShownText = false;
  bool get isShownText => _isShownText;
  set isShownText(bool f) {
    _isShownText = f;
    notifyListeners();
  }

  Future<void> onTapActionButton(int index) async {
    final state = key.currentState;
    if (state != null) {
      state.toggle();
    }

    switch (index) {
      case 0:
        _saveToPost();
        break;
      case 1:
        _shareToTwitter();
        break;
      case 2:
        _saveToLookBook();
        break;
    }
  }

  Future<void> _shareToTwitter() async {
    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        await AIHelpers.shareFileToSocial(model.resultImage);
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

  String _strLoading = '';
  String get strLoading => _strLoading;
  set strLoading(String s) {
    _strLoading = s;
    notifyListeners();
  }

  Future<void> _saveToLookBook() async {
    if (isBusy) return;
    clearErrors();

    strLoading = 'Saving to LOOKBOOK...';
    await runBusyFuture(() async {
      try {
        var hasDescription = await _showDescriptionDialog();
        String? description;
        if (hasDescription == true) {
          description = await AIHelpers.goToDescriptionView(context);
        }

        if (_saveModel == null) {
          var story = StoryModel(
            title: 'VTO',
            text: description ?? 'Virtual Try-On',
            category: 'vote',
            status: 'public',
            medias: [
              MediaStoryModel(link: model.originImage, type: 'image'),
              MediaStoryModel(link: model.resultImage, type: 'image'),
            ],
            updateDate: DateTime.now(),
            timestamp: DateTime.now(),
          );
          await storyService.postStory(story: story);
          AIHelpers.showToast(msg: 'Successfully posted VTO to LOOKBOOK!');
        } else {
          setError('Already posted on LOOKBOOK or Yay/Nay Poll.');
        }
      } catch (e, s) {
        setError(e);
        logger.e(e, stackTrace: s);
      } finally {
        strLoading = '';
      }
    }());

    if (hasError) {
      AIHelpers.showToast(msg: modelError.toString());
    }
  }

  StoryModel? _saveModel;

  Future<void> _saveToPost() async {
    if (isBusy) return;
    clearErrors();

    strLoading = 'Creating Yay/Nay Poll...';

    await runBusyFuture(() async {
      try {
        var hasDescription = await _showDescriptionDialog();
        String? description;
        if (hasDescription == true) {
          description = await AIHelpers.goToDescriptionView(context);
        }
        if (_saveModel != null) {
          _saveModel = _saveModel!.copyWith(status: 'public');
          await storyService.updateStory(story: _saveModel!);
        } else {
          var story = StoryModel(
            title: 'VTO',
            text: description ?? 'Virtual Try-On',
            category: 'vote',
            status: 'public',
            medias: [
              MediaStoryModel(link: model.originImage, type: 'image'),
              MediaStoryModel(link: model.resultImage, type: 'image'),
            ],
            updateDate: DateTime.now(),
            timestamp: DateTime.now(),
          );
          await storyService.postStory(story: story);
        }
        AIHelpers.showToast(msg: 'Successfully posted VTO to Feed!');
      } catch (e, s) {
        setError(e);
        logger.e(e, stackTrace: s);
      } finally {
        strLoading = '';
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
}
