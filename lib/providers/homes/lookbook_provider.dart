import 'package:flutter/material.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class LookbookProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  final PageController _pageController = PageController();
  PageController get pageController => _pageController;
  int _currentPage = 0;

  void init(BuildContext context) async {
    this.context = context;

    _pageController.addListener(() {
      var currentPage = _pageController.page?.round();
      if (currentPage != null && currentPage != _currentPage) {
        _currentPage = currentPage;
        notifyListeners();
      }
    });

    fetchData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  final List<StoryModel> _stories = [];
  List<StoryModel> get stories => _stories;

  Future<void> fetchData() async {
    if (isBusy) return;
    clearErrors();

    _stories.clear();
    await runBusyFuture(() async {
      try {
        var ss = await storyService.getLookBookStories();
        logger.d(ss.length);
        _stories.addAll(ss);
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

  Future<void> onClickSettingButton() async {
    if (isBusy) return;
    clearErrors();
  }
}
