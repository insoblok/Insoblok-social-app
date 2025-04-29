import 'package:flutter/material.dart';
import 'package:insoblok/routers/routers.dart';

import 'package:provider/provider.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class InSoBlokProvider extends InSoBlokViewModel {
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

  late AppProvider _appProvider;

  Future<void> init(BuildContext context) async {
    this.context = context;

    _appProvider = context.read<AppProvider>();
  }

  Future<void> onClickMenuAvatar() async {
    Navigator.of(context).pop();
    Routers.goToAccountPage(context);
  }

  Future<void> onClickMenuMore() async {
    Navigator.of(context).pop();
  }

  Future<void> onClickMenuItem(int index) async {
    Navigator.of(context).pop();
    logger.d(index);
    switch (index) {
      case 7:
        _appProvider.updateTheme();
        break;
    }
  }
}
