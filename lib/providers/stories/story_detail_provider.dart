import 'package:flutter/material.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class StoryDetailProvider extends InSoBlokViewModel {
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

  late StoryModel _story;
  StoryModel get story => _story;
  set story(StoryModel model) {
    _story = model;
    notifyListeners();
  }

  final List<StoryCommentModel> _comments = [];
  List<StoryCommentModel> get comments => _comments;

  void init(BuildContext context, {required StoryModel model}) async {
    this.context = context;
    story = model;

    fetchUser();
  }

  UserModel? _owner;
  UserModel? get owner => _owner;
  set owner(UserModel? model) {
    _owner = model;
    notifyListeners();
  }

  Future<void> fetchUser() async {
    try {
      owner = await userService.getUser(story.userId!);
    } catch (e) {
      setError(e);
      logger.e(e);
    } finally {
      notifyListeners();
    }
  }

  Future<void> getComments() async {
    try {
      List<StoryCommentModel> commentdatas = [];
      // if (feedIndex == 0) {
      //   storydatas = await storyService.getFollowingStories();
      // } else {
      commentdatas = await commentService.getComments(story.id ?? '');
      // }
      _comments.clear();
      logger.d(commentdatas.length);
      _comments.addAll(commentdatas);
    } catch (e) {
      setError(e);
      logger.e(e);
    } finally {
      notifyListeners();
    }
  }

  bool _isLiking = false;
  bool get isLiking => _isLiking;
  set isLiking(bool f) {
    _isLiking = f;
    notifyListeners();
  }

  Future<void> onTapAvatar() async {
    Routers.goToAccountPage(context, user: owner);
  }

  Future<void> updateLike() async {
    if (isBusy) return;
    clearErrors();

    if (story.userId == user?.id) {
      AIHelpers.showToast(msg: 'You can\'t like to your feed!');
      return;
    }

    isLiking = true;
    var likes = List<String>.from(story.likes ?? []);
    await runBusyFuture(() async {
      try {
        if (story.isLike()) {
          likes.remove(user!.id);
        } else {
          likes.add(user!.id!);
        }
        await storyService.updateLikeStory(
          story: story.copyWith(likes: likes, updateDate: DateTime.now()),
          user: owner,
        );
      } catch (e) {
        setError(e);
        logger.e(e);
      } finally {
        isLiking = false;
      }
    }());

    if (hasError) {
      AIHelpers.showToast(msg: modelError.toString());
    } else {
      story = story.copyWith(likes: likes);
      if (story.isLike()) {
        AIHelpers.showToast(msg: 'You liked to a feed!');
      } else {
        AIHelpers.showToast(msg: 'You unliked to a feed!');
      }
      notifyListeners();
    }
  }

  bool _isFollowing = false;
  bool get isFollowing => _isFollowing;
  set isFollowing(bool f) {
    _isFollowing = f;
    notifyListeners();
  }

  Future<void> updateFollow() async {
    if (isBusy) return;
    clearErrors();

    if (story.userId == user?.id) {
      AIHelpers.showToast(msg: 'You can\'t follow to your feed!');
      return;
    }

    isFollowing = true;
    var follows = List<String>.from(story.follows ?? []);
    await runBusyFuture(() async {
      try {
        if (story.isFollow()) {
          follows.remove(user!.id);
        } else {
          follows.add(user!.id!);
        }
        await storyService.updateFollowStory(
          story: story.copyWith(follows: follows, updateDate: DateTime.now()),
          user: owner,
        );
      } catch (e) {
        setError(e);
        logger.e(e);
      } finally {
        isFollowing = false;
      }
    }());

    if (hasError) {
      AIHelpers.showToast(msg: modelError.toString());
    } else {
      story = story.copyWith(follows: follows);
      if (story.isFollow()) {
        AIHelpers.showToast(msg: 'You followed to a feed!');
      } else {
        AIHelpers.showToast(msg: 'You unfollowed to a feed!');
      }
      notifyListeners();
    }
  }

  Future<void> addComment() async {
    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      // try {
      //   var desc = await AIHelpers.goToDescriptionView(context);
      //   if (desc != null) {
      //     var comment = StoryCommentModel(
      //       userId: user?.id,
      //       content: desc,
      //       timestamp: DateTime.now(),
      //     );

      //     var comments = List<StoryCommentModel>.from(story.comments ?? []);
      //     comments.add(comment);
      //     _story = story.copyWith(
      //       comments: comments,
      //       updateDate: DateTime.now(),
      //     );
      //     await storyService.addComment(story: _story);

      //     AIHelpers.showToast(msg: 'Successfully add your comment!');
      //   }
      // } catch (e) {
      //   setError(e);
      //   logger.e(e);
      // } finally {
      //   notifyListeners();
      // }
    }());

    if (hasError) {
      AIHelpers.showToast(msg: modelError.toString());
    }
  }

  Future<void> shareFeed() async {}

  int _tabIndex = 0;
  int get tabIndex => _tabIndex;
  set tabIndex(int i) {
    _tabIndex = i;
    notifyListeners();
  }
}
