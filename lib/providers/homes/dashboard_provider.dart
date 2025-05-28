import 'package:flutter/material.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

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

  final List<NewsModel> _allNewses = [];
  List<NewsModel> get showNewses => _allNewses;

  Future<void> fetchData() async {
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
}
