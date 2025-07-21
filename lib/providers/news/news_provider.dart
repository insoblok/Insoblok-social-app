import 'package:flutter/material.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class NewsProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  void init(BuildContext context) async {
    this.context = context;
    fetchNewsData();
  }

  final List<NewsModel> _allNewses = [];
  List<NewsModel> get showNewses => _allNewses;

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
}
