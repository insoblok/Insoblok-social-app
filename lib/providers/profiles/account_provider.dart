import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:insoblok/generated/l10n.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/pages/pages.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class AccountProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  UserModel? _accountUser;
  UserModel? get accountUser => _accountUser;
  set accountUser(UserModel? model) {
    _accountUser = model;
    notifyListeners();
  }

  bool get isMe => accountUser?.uid == AuthHelper.user?.uid;

  int _pageIndex = 0;
  int get pageIndex => _pageIndex;
  set pageIndex(int i) {
    _pageIndex = i;
    notifyListeners();
  }

  final RoomService _roomService = RoomService();
  RoomService get roomService => _roomService;

  void init(BuildContext context, {UserModel? model}) async {
    this.context = context;
    accountUser = model ?? AuthHelper.user;

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
        var s = await storyService.getStoriesByUid(accountUser!.uid!);
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
    }
  }

  bool _isCreatingRoom = false;
  bool get isCreatingRoom => _isCreatingRoom;
  set isCreatingRoom(bool flag) {
    _isCreatingRoom = flag;
    notifyListeners();
  }

  Future<void> onClickMoreButton() async {
    if (isMe) {
      await Routers.goToAccountUpdatePage(context);
      notifyListeners();
    } else {
      if (isBusy) return;
      clearErrors();

      isCreatingRoom = true;
      await runBusyFuture(() async {
        try {
          var existedRoom = await roomService.getRoomByChatUesr(
            uid: accountUser!.uid!,
          );
          if (existedRoom == null) {
            var room = RoomModel(
              uids: [AuthHelper.user?.uid, accountUser?.uid],
              content:
                  '${AuthHelper.user?.firstName} ${S.current.create_room_message}',
            );
            await roomService.createRoom(room);
            existedRoom = await roomService.getRoomByChatUesr(
              uid: accountUser!.uid!,
            );
          }
          Routers.goToMessagePage(
            context,
            MessagePageData(room: existedRoom!, chatUser: user!),
          );
        } catch (e) {
          logger.e(e);
          setError(e);
        } finally {
          isCreatingRoom = false;
        }
      }());

      if (hasError) {
        Fluttertoast.showToast(msg: modelError.toString());
      }
    }
  }
}
