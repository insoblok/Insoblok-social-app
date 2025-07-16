import 'package:flutter/material.dart';

import 'package:insoblok/routers/routers.dart';
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

  // late AppProvider _appProvider;

  Future<void> init(BuildContext context) async {
    this.context = context;
    // _appProvider = context.read<AppProvider>();
  }

  Future<void> onClickMenuAvatar() async {
    Navigator.of(context).pop();
    Routers.goToAccountPage(context);
  }

  Future<void> onClickMenuMore() async {
    Navigator.of(context).pop();
    Routers.goToSettingPage(context);
  }

  Future<void> onClickPrivacy() async {
    AIHelpers.loadUrl(kPrivacyUrl);
  }

  Future<void> goToAddPost() async {
    Routers.goToAddStoryPage(context);
  }

  Future<void> onClickMenuItem(int index) async {
    Navigator.of(context).pop();
    logger.d(index);
    switch (index) {
      case 0:
        Routers.goToAccountPage(context);
        break;
      case 1:
        Routers.goToAccountListPage(context);
        break;
      case 2:
        Routers.goToAccountTopicPage(context);
        break;
      case 3:
        Routers.goToAccountBookmarkPage(context);
        break;
      case 4:
        Routers.goToLeaderboardPage(context);
        break;
      case 5:
        Routers.goToMarketPlacePage(context);
        break;
      case 6:
        Routers.goToPrivacyPage(context);
        break;
      case 7:
        Routers.goToHelpCenterPage(context);
        break;
      case 8:
        // _appProvider.updateTheme();
        break;
      case 9:
        break;
    }
  }
}
