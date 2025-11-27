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
  int get currentPage => _currentPage;

  void init(BuildContext context) async {
    this.context = context;

    _pageController.addListener(() {
      var currentPage = _pageController.page?.round();
      if (currentPage != null && currentPage != _currentPage) {
        _currentPage = currentPage;
        // Log the current story ID
        if (_currentPage >= 0 && _currentPage < _stories.length) {
          final currentStory = _stories[_currentPage];
          logger.d('📖 Lookbook - Current story ID: ${currentStory.id}');
        }
        notifyListeners();
      }
    });

    fetchData();
    fetchMyStories();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  final List<StoryModel> _stories = [];
  List<StoryModel> get stories => _stories;

  final List<StoryModel> _myStories = [];
  List<StoryModel> get myStories => _myStories;

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
        // Filter out live stream stories (category: 'live') - these are created after live ends
        // They should only show up when actually live, not as past recordings
        var filteredStories =
            ss.where((story) => story.category != 'live').toList();
        _stories.addAll(filteredStories);

        var ids = filteredStories.map((item) => item.id).toList();
        logger.d("reaction ids: $ids");

        filterList(0);
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

  Future<void> fetchMyStories() async {
    _myStories.clear();
    try {
      var ss = await storyService.getStoriesById(AuthHelper.user!.id!);
      // Filter out live stream stories (category: 'live') - these are created after live ends
      // They should only show up when actually live, not as past recordings
      var filteredStories =
          ss.where((story) => story.category != 'live').toList();
      _myStories.addAll(filteredStories);
    } catch (e) {
      setError(e);
      logger.e(e);
    } finally {
      notifyListeners();
    }
  }

  Future<void> filterList(int index) async {
    filterStories.clear();
    if (index == 1) {
      filterStories.addAll(myStories);
    } else {
      for (var story in stories) {
        // Skip live stream stories (category: 'live') - they should only show when actually live
        if (story.category == 'live') {
          continue;
        }

        if (index == 0) {
          if ((story.votes ?? [])
              .map((vote) => vote.userId)
              .toList()
              .contains(AuthHelper.user?.id)) {
            filterStories.add(story);
          }
        } else if (index == 2) {
          // if ((story.comments ?? [])
          //     .map((comment) => comment.userId)
          //     .toList()
          //     .contains(AuthHelper.user?.id)) {
          //   filterStories.add(story);
          // }
        } else if (index == 3) {
          if (story.likes != null &&
              story.likes!.contains(AuthHelper.user?.id)) {
            filterStories.add(story);
          }
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
