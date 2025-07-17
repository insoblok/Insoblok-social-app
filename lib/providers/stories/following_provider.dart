import 'package:flutter/material.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class FollowingProvider extends InSoBlokViewModel {
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

  final List<StoryModel> stories = [];

  Future<void> fetchStories() async {
    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        var followingUsers = await userService.getFollowingUserIds(
          userid: user!.id!,
        );

        var storyList = await storyService.getStories();
        for (var story in storyList) {
          if (followingUsers.contains(story.userId)) {
            stories.add(story);
          }
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
    } else {}
  }
}
