import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

const kDashbordPageTitles = [
  'ALL',
  'US Government',
  'Tech',
  'Finance',
  'Left-leaning',
  'Sports',
  'Right-leaning',
  'Most popular',
];

class DashboardProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  int _pageIndex = 0;
  int get pageIndex => _pageIndex;
  set pageIndex(int i) {
    _pageIndex = i;
    notifyListeners();
  }

  void init(BuildContext context) async {
    this.context = context;

    fetchData();
  }

  final _newsService = NewsService();
  NewsService get newsService => _newsService;

  List<NewsModel> get showns {
    if (pageIndex == 0) return _allNewses;
    List<NewsModel> result = [];
    var tagName = kDashbordPageTitles[pageIndex];
    for (var news in _allNewses) {
      var flag = false;
      for (var category in (news.categories ?? [])) {
        if (category['name'] == tagName) {
          flag = true;
        }
      }
      if (flag) {
        result.add(news);
      }
    }
    return result;
  }

  final List<NewsModel> _allNewses = [];

  Future<void> fetchData() async {
    if (isBusy) return;
    clearErrors();

    _allNewses.clear();
    await runBusyFuture(() async {
      try {
        var news = await newsService.getNews();
        logger.d(news.length);
        _allNewses.addAll(news);
      } catch (e) {
        setError(e);
        logger.e(e);
      } finally {
        notifyListeners();
      }
    }());

    if (hasError) {
      Fluttertoast.showToast(msg: modelError.toString());
    }
  }
}
