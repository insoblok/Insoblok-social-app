import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

final kMediaDetailIconData = [
  {'title': 'Remix', 'icon': AIImages.icBottomLook},
  {'title': 'Repost', 'icon': AIImages.icRetwitter},
  {'title': 'Boost', 'icon': AIImages.icMenuMoments},
];

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

  void onClickActionButton(int index) {
    switch (index) {
      case 0:
        onEventRemix();
      case 1:
        onEventRepost();
      case 2:
        onEventBoost();
    }
  }

  bool _isRemixing = false;
  bool get isRemixing => _isRemixing;
  set isRemixing(bool f) {
    _isRemixing = f;
    notifyListeners();
  }

  Future<void> onEventRemix() async {
    if (isBusy) return;
    clearErrors();

    isRemixing = true;
    await runBusyFuture(() async {
      try {
        var result = await NetworkUtil.getVTOEditImage(
          model: _medias[index],
          clothingType: 'auto',
          prompt: 'Change the garment color to blue',
        );
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

  Future<void> onEventRepost() async {}

  Future<void> onEventBoost() async {}
}
