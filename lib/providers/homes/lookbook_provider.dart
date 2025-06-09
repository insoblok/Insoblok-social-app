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

  int _tabIndex = 0;
  int get tabIndex => _tabIndex;
  set tabIndex(int d) {
    _tabIndex = d;
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

  List<StoryModel> _filterStories = [];
  List<StoryModel> get filterStories => _filterStories;
  set filterStories(List<StoryModel> d) {
    _filterStories = d;
    notifyListeners();
  }

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

  Future<void> filterList(int index) async {
    filterStories.clear();
    for (var story in stories) {
      if (index == 0) {
        if (story.uid == AuthHelper.user?.uid) {
          filterStories.add(story);
        }
      } else if (index == 1) {
        if ((story.comments ?? [])
            .map((comment) => comment.uid)
            .toList()
            .contains(AuthHelper.user?.uid)) {
          filterStories.add(story);
        }
      } else if (index == 2) {
        if (story.likes != null &&
            story.likes!.contains(AuthHelper.user?.uid)) {
          filterStories.add(story);
        }
      }
    }
    notifyListeners();
  }

  Future<void> onClickSettingButton() async {
    if (isBusy) return;
    clearErrors();
  }
}
