import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class TopicProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  Future<void> init(BuildContext context) async {
    this.context = context;

    fetchStories();
  }

  final _storyService = StoryService();
  StoryService get storyService => _storyService;

  final List<StoryModel> stories = [];

  Future<void> fetchStories() async {
    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        var s = await storyService.getStoriesByLike(user!.uid!);
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
      Fluttertoast.showToast(msg: modelError.toString());
    } else {}
  }
}
