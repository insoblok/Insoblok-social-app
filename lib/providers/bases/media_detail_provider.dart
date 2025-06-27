import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

final kMediaDetailIconData = [
  {'title': 'Remix', 'icon': AIImages.icBottomLook},
  {'title': 'Repost', 'icon': AIImages.icRetwitter},
  {'title': 'Boost', 'icon': AIImages.icMenuMoments},
];

final kRemixColorSet = {
  'white': Colors.white,
  'black': Colors.black,
  'red': Colors.red,
  'green': Colors.green,
  'blue': Colors.blue,
  'yellow': Colors.yellow,
  'puple': Colors.purple,
  'pink': Colors.pink,
  'amber': Colors.amber,
  'brown': Colors.brown,
  'cyan': Colors.cyan,
  'orange': Colors.orange,
};

class MediaDetailModel {
  final List<String> medias;
  final int index;

  MediaDetailModel({required this.medias, required this.index});
}

class MediaDetailProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  final controller = PageController();

  final List<String> _medias = [];
  List<String> get medias => _medias;

  int _index = 0;
  int get index => _index;
  set index(int i) {
    _index = i;
    notifyListeners();
  }

  Future<void> init(
    BuildContext context, {
    required MediaDetailModel model,
  }) async {
    this.context = context;

    _medias.addAll(model.medias);
    index = model.index;

    Future.delayed(const Duration(milliseconds: 300), () {
      controller.jumpToPage(index);
    });
  }

  var globalkey = GlobalKey();

  bool _isRemixingDialog = false;
  bool get isRemixingDialog => _isRemixingDialog;
  set isRemixingDialog(bool f) {
    _isRemixingDialog = f;
    notifyListeners();
  }

  void onClickActionButton(int index) {
    switch (index) {
      case 0:
        isRemixingDialog = true;
        break;
      case 1:
        onEventRepost();
        break;
      case 2:
        onEventBoost();
        break;
    }
  }

  String _imgRemix = '';
  String get imgRemix => _imgRemix;
  set imgRemix(String s) {
    _imgRemix = s;
    notifyListeners();
  }

  String _remixKey = '';
  String get remixKey => _remixKey;
  set remixKey(String s) {
    _remixKey = s;
    notifyListeners();
  }

  bool _isRemixing = false;
  bool get isRemixing => _isRemixing;
  set isRemixing(bool f) {
    _isRemixing = f;
    notifyListeners();
  }

  Future<void> onEventRemix() async {
    if (remixKey.isEmpty) return;

    if (isBusy) return;
    clearErrors();

    isRemixingDialog = false;
    isRemixing = true;

    await runBusyFuture(() async {
      try {
        var result = await NetworkUtil.getVTOEditImage(
          model: _medias[index],
          prompt: 'Change the garment color to $remixKey',
        );

        if (result != null) {
          imgRemix = result;
        } else {
          setError('Remix service error!');
        }
      } catch (e) {
        setError(e);
        logger.e(e);
      } finally {
        isRemixing = false;
      }
    }());

    if (hasError) {
      Fluttertoast.showToast(msg: modelError.toString());
    }
  }

  Future<void> onEventRepost() async {
    await _saveToPost();
  }

  Future<void> onEventBoost() async {
    AIHelpers.showToast(msg: 'This feature will come soon!');
  }

  Future<void> _saveToPost() async {
    if (imgRemix.isEmpty) {
      AIHelpers.showToast(msg: 'You have not remix data yet!');
      return;
    }
    if (isBusy) return;
    clearErrors();

    isRemixing = true;

    await runBusyFuture(() async {
      try {
        var hasDescription = await AIHelpers.showDescriptionDialog(context);
        String? description;
        if (hasDescription == true) {
          description = await AIHelpers.goToDescriptionView(context);
        }

        var path = await _makeRemixImage();

        if (path == null) throw ('Something went wrong!');

        var imageUrl = await FirebaseHelper.uploadFile(
          file: File(path),
          folderName: 'remix',
        );
        var story = StoryModel(
          title: 'REMIX',
          text: description ?? 'Creating Remix Yay/Nay Poll...',
          category: 'vote',
          status: 'public',
          medias: [MediaStoryModel(link: imageUrl, type: 'image')],
          updateDate: DateTime.now(),
          timestamp: DateTime.now(),
        );
        await storyService.postStory(story: story);
        AIHelpers.showToast(msg: 'Successfully posted Remix to Feed!');
      } catch (e, s) {
        setError(e);
        logger.e(e, stackTrace: s);
      } finally {
        isRemixing = false;
      }
    }());

    if (hasError) {
      AIHelpers.showToast(msg: modelError.toString());
    }
  }

  Future<String?> _makeRemixImage() async {
    var boundary =
        globalkey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary != null) {
      var image = await boundary.toImage();
      var byteData = await image.toByteData(format: ImageByteFormat.png);
      var pngBytes = byteData?.buffer.asUint8List();

      final directory = (await getApplicationDocumentsDirectory()).path;
      var imgFile = File('$directory/screenshot.png');
      await imgFile.writeAsBytes(pngBytes!);

      return imgFile.path;
    }

    return null;
  }
}
