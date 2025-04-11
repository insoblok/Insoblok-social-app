import 'package:flutter/material.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/pages/pages.dart';
import 'package:insoblok/utils/utils.dart';

class MessageProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  late RoomModel _room;
  RoomModel get room => _room;
  set room(RoomModel model) {
    _room = model;
    notifyListeners();
  }

  late UserModel _chatUser;
  UserModel get chatUser => _chatUser;
  set chatUser(UserModel model) {
    _chatUser = model;
    notifyListeners();
  }

  Future<void> init(
    BuildContext context, {
    required MessagePageData data,
  }) async {
    this.context = context;
    room = data.room;
    chatUser = data.chatUser;
  }
}
