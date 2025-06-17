import 'package:flutter/material.dart';

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

  void init(BuildContext context, {required StoryCommentModel model}) async {
    this.context = context;
    comment = model;

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
      owner = await userService.getUser(comment.userId!);
    } catch (e) {
      setError(e);
      logger.e(e);
    } finally {
      notifyListeners();
    }
  }

  Future<void> onTapUserAvatar() async {
    Routers.goToAccountPage(context, user: owner);
  }
}
