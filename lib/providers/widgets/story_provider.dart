import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class StoryProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  late StoryModel _story;
  StoryModel get story => _story;
  set story(StoryModel model) {
    _story = model;
    notifyListeners();
  }

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
      owner = await FirebaseHelper.getUser(story.uid!);
    } catch (e) {
      setError(e);
      logger.e(e);
    } finally {
      notifyListeners();
    }
  }

  int _pageIndex = 0;
  int get pageIndex => _pageIndex;
  set pageIndex(int i) {
    _pageIndex = i;
    notifyListeners();
  }

  Future<void> goToDetailPage() async {
    var data = await Routers.goToStoryDetailPage(context, story);
    if (data != null) {
      story = data;
      notifyListeners();
    }
  }

  final _storyService = StoryService();
  StoryService get storyService => _storyService;

  bool _isLiking = false;
  bool get isLiking => _isLiking;
  set isLiking(bool f) {
    _isLiking = f;
    notifyListeners();
  }

  Future<void> updateLike() async {
    if (isBusy) return;
    clearErrors();

    if (story.uid == user?.uid) {
      Fluttertoast.showToast(msg: 'You can\'t like to your feed!');
      return;
    }

    isLiking = true;
    var likes = List<String>.from(story.likes ?? []);
    await runBusyFuture(() async {
      try {
        if (story.isLike()) {
          likes.remove(user!.uid);
        } else {
          likes.add(user!.uid!);
        }
        await storyService.updateLikeStory(
          story: story.copyWith(likes: likes),
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
      Fluttertoast.showToast(msg: modelError.toString());
    } else {
      story = story.copyWith(likes: likes);
      if (story.isLike()) {
        Fluttertoast.showToast(msg: 'You liked to a feed!');
      } else {
        Fluttertoast.showToast(msg: 'You unliked to a feed!');
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

    if (story.uid == user?.uid) {
      Fluttertoast.showToast(msg: 'You can\'t follow to your feed!');
      return;
    }

    isFollowing = true;
    var follows = List<String>.from(story.follows ?? []);
    await runBusyFuture(() async {
      try {
        if (story.isFollow()) {
          follows.remove(user!.uid);
        } else {
          follows.add(user!.uid!);
        }
        await storyService.updateFollowStory(
          story: story.copyWith(follows: follows),
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
      Fluttertoast.showToast(msg: modelError.toString());
    } else {
      story = story.copyWith(follows: follows);
      if (story.isFollow()) {
        Fluttertoast.showToast(msg: 'You followed to a feed!');
      } else {
        Fluttertoast.showToast(msg: 'You unfollowed to a feed!');
      }
      notifyListeners();
    }
  }

  Future<void> addComment() async {
    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        var desc = await Routers.goToQuillDescriptionPage(context);
        logger.d(desc);
        if ((desc as List<Map<String, dynamic>>?)?.isNotEmpty ?? false) {
          final converter = QuillDeltaToHtmlConverter(
            desc!,
            ConverterOptions.forEmail(),
          );
          var content = converter.convert();
          var comment = StoryCommentModel(uid: user?.uid, content: content);
          var comments = List<StoryCommentModel>.from(story.comments ?? []);
          comments.add(comment);
          story = story.copyWith(comments: comments);
          await storyService.addComment(story: story);

          Fluttertoast.showToast(msg: 'Successfully add your comment!');
        } else {
          setError('Your comment is empty!');
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
    }
  }
}
