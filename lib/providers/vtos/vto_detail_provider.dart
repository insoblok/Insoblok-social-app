import 'package:flutter/material.dart';

import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class VTODetailPageModel {
  final ProductModel product;
  final String originImage;
  final double? originImgWidth;
  final double? originImgHeight;
  final String resultImage;
  final double? resultImgWidth;
  final double? resultImgHeight;
  final String? resultVideo; // Optional video URL from Runware

  VTODetailPageModel({
    required this.product,
    required this.originImage,
    this.originImgWidth,
    this.originImgHeight,
    required this.resultImage,
    this.resultImgWidth,
    this.resultImgHeight,
    this.resultVideo,
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
        _saveToLookBook(); // Post to Lookbook only
        break;
      case 1:
        _shareToTwitter();
        break;
      case 2:
        _saveToPostAndLookBook(); // Post to both main page and lookbook
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

    await runBusyFuture(() async {
      try {
        var hasDescription = await AIHelpers.showDescriptionDialog(context);
        String? description;
        if (hasDescription == true) {
          description = await AIHelpers.goToDescriptionView(context);
        }

        strLoading = 'Saving to LOOKBOOK...';

        // Build medias list for lookbook: origin image, result image, then video
        final List<MediaStoryModel> medias = [];

        // Add origin image first
        if (model.originImage.isNotEmpty) {
          medias.add(
            MediaStoryModel(
              link: model.originImage,
              width: model.originImgWidth,
              height: model.originImgHeight,
              type: 'image',
            ),
          );
        }

        // Add result image (VTO image) second
        if (model.resultImage.isNotEmpty) {
          medias.add(
            MediaStoryModel(
              link: model.resultImage,
              width: model.resultImgWidth,
              height: model.resultImgHeight,
              type: 'image',
            ),
          );
        }

        // Add video last (if available)
        if (model.resultVideo != null && model.resultVideo!.isNotEmpty) {
          medias.add(MediaStoryModel(link: model.resultVideo!, type: 'video'));
        }

        var story = StoryModel(
          title: 'VTO',
          text: description ?? 'Vote to Earn – Vybe Virtual Try-On',
          category: 'vote',
          status: 'public',
          medias: medias,
          updatedAt: DateTime.now(),
          createdAt: DateTime.now(),
        );

        final storyId = await storyService.postStory(story: story);
        AIHelpers.showToast(msg: 'Successfully posted VTO video to LOOKBOOK!');

        // Fetch the posted story and navigate to lookbook detail page
        final postedStory = await storyService.getStory(storyId);
        await Routers.goToLookbookDetailPage(context, postedStory);
      } catch (e, s) {
        setError(e);
        logger.e(e, stackTrace: s);
      } finally {
        strLoading = '';
        notifyListeners();
      }
    }());

    if (hasError) {
      AIHelpers.showToast(msg: modelError.toString());
    }
  }

  StoryModel? _saveModel;

  /// Helper method to build medias list with video, origin image, and VTO image
  /// All media items are added together in one story (video + images)
  List<MediaStoryModel> _buildMediasList() {
    final List<MediaStoryModel> medias = [];

    // Add video first if available (explicitly marked as video)
    if (model.resultVideo != null && model.resultVideo!.isNotEmpty) {
      medias.add(
        MediaStoryModel(
          link: model.resultVideo!,
          type: 'video', // Explicitly set as video
        ),
      );
    }

    // Add origin image (explicitly marked as image)
    if (model.originImage.isNotEmpty) {
      medias.add(
        MediaStoryModel(
          link: model.originImage,
          width: model.originImgWidth,
          height: model.originImgHeight,
          type: 'image', // Explicitly set as image
        ),
      );
    }

    // Add result image (VTO image) - explicitly marked as image
    if (model.resultImage.isNotEmpty) {
      medias.add(
        MediaStoryModel(
          link: model.resultImage,
          width: model.resultImgWidth,
          height: model.resultImgHeight,
          type: 'image', // Explicitly set as image
        ),
      );
    }

    return medias;
  }

  Future<void> _saveToPost() async {
    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        var hasDescription = await AIHelpers.showDescriptionDialog(context);
        String? description;
        if (hasDescription == true) {
          description = await AIHelpers.goToDescriptionView(context);
        }

        strLoading = 'Creating Yay/Nay Poll...';

        if (_saveModel != null) {
          _saveModel = _saveModel!.copyWith(status: 'public');
          await storyService.updateStory(story: _saveModel!);
        } else {
          final medias = _buildMediasList();

          var story = StoryModel(
            title: 'VTO',
            text: description ?? 'Vote to Earn – Vybe Virtual Try-On',
            category: 'vote',
            status: 'public',
            medias: medias,
            updatedAt: DateTime.now(),
            createdAt: DateTime.now(),
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

  /// Post to both main page (feed) and lookbook
  Future<void> _saveToPostAndLookBook() async {
    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        var hasDescription = await AIHelpers.showDescriptionDialog(context);
        String? description;
        if (hasDescription == true) {
          description = await AIHelpers.goToDescriptionView(context);
        }

        strLoading = 'Posting to Feed and LOOKBOOK...';

        // Build medias for feed: video first, then origin image, then result image
        final feedMedias = _buildMediasList();

        // Post to main feed
        if (_saveModel != null) {
          _saveModel = _saveModel!.copyWith(status: 'public');
          await storyService.updateStory(story: _saveModel!);
        } else {
          var feedStory = StoryModel(
            title: 'VTO',
            text: description ?? 'Vote to Earn – Vybe Virtual Try-On',
            category: 'vote',
            status: 'public',
            medias: feedMedias,
            updatedAt: DateTime.now(),
            createdAt: DateTime.now(),
          );
          await storyService.postStory(story: feedStory);
        }

        // Build medias for lookbook: origin image, result image, then video
        final List<MediaStoryModel> lookbookMedias = [];

        // Add origin image first
        if (model.originImage.isNotEmpty) {
          lookbookMedias.add(
            MediaStoryModel(
              link: model.originImage,
              width: model.originImgWidth,
              height: model.originImgHeight,
              type: 'image',
            ),
          );
        }

        // Add result image (VTO image) second
        if (model.resultImage.isNotEmpty) {
          lookbookMedias.add(
            MediaStoryModel(
              link: model.resultImage,
              width: model.resultImgWidth,
              height: model.resultImgHeight,
              type: 'image',
            ),
          );
        }

        // Add video last (if available)
        if (model.resultVideo != null && model.resultVideo!.isNotEmpty) {
          lookbookMedias.add(
            MediaStoryModel(link: model.resultVideo!, type: 'video'),
          );
        }

        // Post to lookbook (separate story with different media order)
        var lookbookStory = StoryModel(
          title: 'VTO',
          text: description ?? 'Vote to Earn – Vybe Virtual Try-On',
          category: 'vote',
          status: 'public',
          medias: lookbookMedias,
          updatedAt: DateTime.now(),
          createdAt: DateTime.now(),
        );
        final lookbookStoryId = await storyService.postStory(
          story: lookbookStory,
        );

        AIHelpers.showToast(
          msg: 'Successfully posted VTO to Feed and LOOKBOOK!',
        );

        // Fetch the posted lookbook story and navigate to lookbook detail page
        final postedStory = await storyService.getStory(lookbookStoryId);
        await Routers.goToLookbookDetailPage(context, postedStory);
      } catch (e, s) {
        setError(e);
        logger.e(e, stackTrace: s);
      } finally {
        strLoading = '';
        notifyListeners();
      }
    }());

    if (hasError) {
      AIHelpers.showToast(msg: modelError.toString());
    }
  }
}
