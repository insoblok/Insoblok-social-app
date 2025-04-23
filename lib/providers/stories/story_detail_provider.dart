import 'package:flutter/material.dart';

import 'package:insoblok/utils/utils.dart';

class StoryDetailProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  List<String> images = [
    AIImages.imgBackDashboard,
    AIImages.imgBackChat,
    AIImages.imgBackLike,
    AIImages.imgBackProfile,
  ];

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;
  set currentIndex(int i) {
    _currentIndex = i;
    notifyListeners();
  }

  Future<void> init(BuildContext context) async {
    this.context = context;
  }
}
