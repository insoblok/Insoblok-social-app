import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/routers/router.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/locator.dart';

class DashboardProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  int _tabIndex = -1; // -1 means no tab selected initially
  int get tabIndex => _tabIndex;
  set tabIndex(int d) {
    _tabIndex = d;
    notifyListeners();
  }

  int _feedIndex = 1;
  int get feedIndex => _feedIndex;
  set feedIndex(int d) {
    _feedIndex = d;
    notifyListeners();
  }

  bool _isUpdated = false;
  bool get isUpdated => _isUpdated;
  set isUpdated(bool f) {
    _isUpdated = f;
    notifyListeners();
  }

  bool _showSearch = false;
  bool get showSearch => _showSearch;
  set showSearch(bool f) {
    _showSearch = f;
    notifyListeners();
  }

  final PageController _pageController = PageController();
  PageController get pageController => _pageController;
  int _currentPage = 0;

  final MediaPickerService mediaPickerService = locator<MediaPickerService>();

  void init(BuildContext context) async {
    this.context = context;
    _pageController.addListener(() {
      var currentPage = _pageController.page?.round();
      if (currentPage != null && currentPage != _currentPage) {
        _currentPage = currentPage;
        // Log the current story ID when page changes
        if (_currentPage >= 0 && _currentPage < stories.length) {
          final currentStory = stories[_currentPage];
          logger.d('📰 PageView - Current feed/story ID: ${currentStory.id}');
        }
        notifyListeners();
      }
    });

    fetchStoryData();

    storyService.getStoryUpdated().listen((updated) {
      isUpdated = true;
    });

    storyService.getStoriesStream().listen((sList) {
      _stories.value = sList;
      isUpdated = true;
    });
  }

  void handleChangeStory(index) {
    if (index >= 0 && index < stories.length) {
      final currentStory = stories[index];
      logger.d('📰 Current feed/story ID: ${currentStory.id}');
      mediaPickerService.currentStory = currentStory;
    }
  }

  final List<NewsModel> _allNewses = [];
  List<NewsModel> get showNewses => _allNewses;

  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  Future<void> fetchNewsData() async {
    if (isBusy) return;
    clearErrors();

    _allNewses.clear();
    await runBusyFuture(() async {
      try {
        var result = await newsService.getNews();
        logger.d(result.length);
        if (result.isEmpty) {
          result = await newsService.getNewsFromService();
          if (result.isNotEmpty) {
            for (var news in result) {
              await newsService.addNews(news);
            }
          }
        }
        _allNewses.addAll(result);
        logger.d(_allNewses.length);
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

  final ReactiveValue<List<StoryModel>> _stories =
      ReactiveValue<List<StoryModel>>([]);
  List<StoryModel> get stories => _stories.value;
  set stories(List<StoryModel> s) {
    _stories.value = s;
    notifyListeners();
  }

  Future<void> fetchStoryData() async {
    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        List<StoryModel> storydatas = [];
        // if (feedIndex == 0) {
        //   storydatas = await storyService.getFollowingStories();
        // } else {
        storydatas = await storyService.getStories();

        // }
        _stories.value.clear();
        _stories.value.addAll(storydatas);
        isUpdated = false;
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

  void onClickFeedOptionButton(int index) {
    feedIndex = index;
    fetchStoryData();
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
                  leading: const Icon(
                    Icons.videocam_outlined,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Create Post',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
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
    fetchStoryData();
  }

  void onSearchChanged(String value) {
    // TODO: filter your stories/users/etc. here if desired
    notifyListeners(); // so suffix clear button appears/disappears
  }

  void onSearchSubmitted(String value) {
    // TODO: submit search / navigate / fetch results
  }

  void clearSearch() {
    searchController.clear();
    notifyListeners();
  }

  Future<void> onClickMenuItem(int index) async {
    switch (index) {
      case 0:
        Routers.goToLookbookPage(context);
        break;
      case 1:
        Routers.goToMarketPlacePage(context);
        break;
      case 2:
        Routers.goToMarketPlacePage(context);
        break;
      case 3:
        Routers.goToFriendPage(context);
        break;
      case 4:
        Routers.goToNewsPage(context);
        break;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }
}
