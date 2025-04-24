import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

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

  bool _isUpdated = false;
  bool get isUpdated => _isUpdated;
  set isUpdated(bool f) {
    _isUpdated = f;
    notifyListeners();
  }

  void init(BuildContext context) async {
    this.context = context;

    fetchData();

    storyService.getStoryUpdated().listen((updated) {
      isUpdated = true;
    });
  }

  final _storyService = StoryService();
  StoryService get storyService => _storyService;

  final List<StoryModel> _stories = [];
  List<StoryModel> get stories => _stories;

  Future<void> fetchData() async {
    if (isBusy) return;
    clearErrors();

    _stories.clear();
    try {
      var ss = await storyService.getStories();
      logger.d(ss.length);
      _stories.addAll(ss);
      isUpdated = false;
    } catch (e) {
      setError(e);
      logger.e(e);
    } finally {
      notifyListeners();
    }

    if (hasError) {
      Fluttertoast.showToast(msg: modelError.toString());
    }
  }
}
