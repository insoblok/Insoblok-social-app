import 'package:aiavatar/utils/utils.dart';
import 'package:flutter/material.dart';

class AIAvatarProvider extends AIAvatarViewModel {
  var _pageIndex = 0;
  int get pageIndex => _pageIndex;
  set pageIndex(int i) {
    _pageIndex = i;
    notifyListeners();
  }

  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  Future<void> init(BuildContext context) async {
    this.context = context;
  }
}
