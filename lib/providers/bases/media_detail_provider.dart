import 'package:flutter/material.dart';

import 'package:insoblok/utils/utils.dart';

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
}
