import 'package:flutter/material.dart';
import 'package:googleapis/artifactregistry/v1.dart';

import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/locator.dart';


class InSoBlokProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  var _pageIndex = 0;
  int get pageIndex => _pageIndex;
  set pageIndex(int i) {
    _pageIndex = i;
    notifyListeners();
  }

  bool _showSearch = false;
  bool get showSearch => _showSearch;
  set showSearch(bool f) {
    _showSearch = f;
    notifyListeners();
  }

  var _dotIndex = 0;
  int get dotIndex => _dotIndex;
  set dotIndex(int i) {
    _dotIndex = i;
    notifyListeners();
  }

  final MediaPickerService mediaPickerService = locator<MediaPickerService>();

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
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black87,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.videocam_outlined, color: Colors.white),
                title: const Text(
                  'Create Post',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  Routers.goToCreatePostPage(context);
                },
              ),
            ],
          ),
        ),
        );
      },
    );
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

  Future<void> handleTapCreateVTOPost() async {
    List<String> mediaString = (mediaPickerService.currentStory?.medias ?? []).map((m) => m.link ?? "").toList();
    await AIHelpers.goToDetailView(context, medias: mediaString);
  }

  void toggleSearch() {
    showSearch = !showSearch;
    notifyListeners();
  }

  void exitSearch() {
    showSearch = false;
    notifyListeners();
  }
}
