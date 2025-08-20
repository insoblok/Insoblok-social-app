import 'package:flutter/material.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';

import 'package:insoblok/utils/utils.dart';

class PostDetailProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  late PageController _pageController;
  PageController get pageController => _pageController;
  int _currentPage = 0;

  final List<StoryModel> _stories = [];
  List<StoryModel> get stories => _stories;

  late String _userid;
  String get userid => _userid;
  set userid(String id) {
    _userid = id;
    notifyListeners();
  }

  int _index = 0;
  int get index => _index;
  set index(int d) {
    _index = d;
    notifyListeners();
  }

  Future<void> init(
    BuildContext context, {
    required Map<String, dynamic> data,
  }) async {
    this.context = context;

    _userid = data['userid'];
    _index = data['index'];

    _pageController = PageController(initialPage: _index);
    _pageController.addListener(() {
      var currentPage = _pageController.page?.round();
      if (currentPage != null && currentPage != _currentPage) {
        _currentPage = currentPage;
        notifyListeners();
      }
    });
    await fetchStories();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> fetchStories() async {
    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        logger.d(_userid);
        var s = await storyService.getStoriesById(_userid);

        if (s.isNotEmpty) {
          stories.clear();
          stories.addAll(s);
        }
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
}
