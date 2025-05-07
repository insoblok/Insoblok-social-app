import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class RoomProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  UserModel? _chatUser;
  UserModel? get chatUser => _chatUser;
  set chatUser(UserModel? model) {
    _chatUser = model;
    notifyListeners();
  }

  late RoomModel _room;
  RoomModel get room => _room;
  set room(RoomModel model) {
    _room = model;
    notifyListeners();
  }

  Future<void> init(BuildContext context, {required RoomModel model}) async {
    this.context = context;
    room = model;

    fetchUser();
  }

  Future<void> fetchUser() async {
    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        var chatUserId = room.uid;
        if (room.uid == user?.uid) {
          chatUserId = (room.uids ?? [])[1];
        }
        chatUser = await FirebaseHelper.getUser(chatUserId!);
        if (chatUser == null) {
          setError('Firebase Error! Please try again later.');
        } else {
          FirebaseHelper.getUserStream(chatUser!.id!).listen((data) {
            chatUser = data.data();
          });
        }
      } catch (e) {
        logger.e(e);
        setError(e);
      } finally {
        notifyListeners();
      }
    }());

    if (hasError) {
      Fluttertoast.showToast(msg: modelError.toString());
    }
  }
}
