import 'package:flutter/material.dart';
import 'package:insoblok/extensions/extensions.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class CommentProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  late StoryCommentModel _comment;
  StoryCommentModel get comment => _comment;
  set comment(StoryCommentModel model) {
    _comment = model;
    notifyListeners();
  }

  bool _isShowReplies = false;
  bool get isShowReplies => _isShowReplies;
  set isShowReplies(bool f) {
    _isShowReplies = f;
    notifyListeners();
  }

  final List<StoryCommentModel> _commentReplies = [];
  List<StoryCommentModel> get commentReplies => _commentReplies;

  void init(BuildContext context, {required StoryCommentModel model}) async {
    this.context = context;
    comment = model;

    fetchUser();
    getCommentReplies();
  }

  UserModel? _owner;
  UserModel? get owner => _owner;
  set owner(UserModel? model) {
    _owner = model;
    notifyListeners();
  }

  Future<void> fetchUser() async {
    try {
      owner = await userService.getUser(comment.userId!);
    } catch (e) {
      setError(e);
      logger.e(e);
    } finally {
      notifyListeners();
    }
  }

  Future<void> getCommentReplies() async {
    try {
      List<StoryCommentModel> commentdatas = [];
      commentdatas = await commentService.getComments(comment.storyId ?? '');
      _commentReplies.clear();
      for (var item in commentdatas) {
        if (item.commentId == comment.id) {
          _commentReplies.add(item);
        }
      }
    } catch (e) {
      setError(e);
      logger.e(e);
    } finally {
      notifyListeners();
    }
  }

  Future<void> updateLike() async {
    if (isBusy) return;
    clearErrors();

    if (comment.userId == user?.id) {
      AIHelpers.showToast(msg: 'You can\'t like to your own comment!');
      return;
    }

    var likes = List<String>.from(comment.likes ?? []);
    await runBusyFuture(() async {
      try {
        if (comment.isLike()) {
          likes.remove(user!.id);
        } else {
          likes.add(user!.id!);
        }
        await commentService.updateLikeComment(
          comment: comment.copyWith(likes: likes, timestamp: DateTime.now()),
        );
        comment = comment.copyWith(likes: likes);
      } catch (e) {
        setError(e);
        logger.e(e);
      } finally {}
    }());

    if (hasError) {
      AIHelpers.showToast(msg: modelError.toString());
    }
  }

  Future<void> onTapUserAvatar() async {
    Routers.goToAccountPage(context, user: owner);
  }
}
