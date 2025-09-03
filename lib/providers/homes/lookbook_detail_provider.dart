import 'package:flutter/material.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class LookbookDetailProvider extends InSoBlokViewModel {
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

  late StoryModel _story;
  StoryModel get story => _story;
  set story(StoryModel model) {
    _story = model;
    notifyListeners();
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

  final PageController _pageController = PageController();
  PageController get pageController => _pageController;
  int _currentPage = 0;

  // void init(BuildContext context) async {
  void init(BuildContext context, {required StoryModel model}) async {
    this.context = context;
    story = model;

    _pageController.addListener(() {
      var currentPage = _pageController.page?.round();
      if (currentPage != null && currentPage != _currentPage) {
        _currentPage = currentPage;
        notifyListeners();
      }
    });

    _stories.clear();
    _stories.add(story);

    _myStories.clear();
    _myStories.add(story);

    filterList(0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  
  Future<void> filterList(int index) async {
    filterStories.clear();
    if (index == 1) {
      filterStories.addAll(myStories);
    } else {
      for (var story in stories) {
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
