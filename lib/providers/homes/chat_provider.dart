import 'package:flutter/material.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/pages/pages.dart';
import 'package:insoblok/routers/router.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

class ChatProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  final List<RoomModel> _rooms = [];
  List<RoomModel> get rooms => _rooms;

  String? _balance;
  String? get balance => _balance;
  set balance(String? s) {
    _balance = s;
    notifyListeners();
  }

  Future<void> init(BuildContext context) async {
    this.context = context;

    await runBusyFuture(() async {
      await fetchData();
    }());

    roomService.getRoomsStream().listen((queryRooms) {
      for (var doc in queryRooms.docs) {
        var json = doc.data();
        json['id'] = doc.id;
        var room = RoomModel.fromJson(json);
        if (rooms.map((r) => r.id).toList().contains(room.id)) {
          continue;
        }
        if (room.uids != null && room.uids!.contains(AuthHelper.user?.uid)) {
          _rooms.add(room);
        }
      }
      logger.d(_rooms.length);
      fetchData();
    });
  }

  Future<void> fetchData() async {
    _rooms.clear();
    _rooms.addAll(await roomService.getRooms());
    await geChatList();
  }

  Future<void> geChatList() async {
    try {
      List<RoomModel> newUsers = [];

      var keyUsers = await userService.getAllUsers();
      List<String?> userUids = [];
      for (var room in _rooms) {
        userUids.addAll(room.uids ?? []);
      }
      for (var user in keyUsers) {
        if (user != null) {
          if (userUids.contains(user.uid)) continue;
          newUsers.add(RoomModel(uid: user.uid));
        }
      }
      _rooms.addAll(newUsers);
      logger.d(_rooms.length);
    } catch (e) {
      logger.e(e);
      setError(e);
    } finally {
      notifyListeners();
    }
  }

  Future<void> gotoNewChat(UserModel? chatUser) async {
    if (isBusy || chatUser == null) return;
    clearErrors();

    RoomModel? existedRoom;

    await runBusyFuture(() async {
      try {
        existedRoom = await roomService.getRoomByChatUesr(uid: chatUser.uid!);
        if (existedRoom == null) {
          var dialog = await showDialog<bool>(
            context: context,
            builder: (context) {
              return Scaffold(
                backgroundColor: AIColors.transparent,
                body: Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 32.0),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 24.0,
                    ),
                    decoration: BoxDecoration(
                      color: AIColors.pink,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Create Room",
                              style: TextStyle(
                                fontSize: 18.0,
                                color: AIColors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () => Navigator.of(context).pop(),
                              icon: Icon(Icons.close, color: AIColors.white),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24.0),
                        Text(
                          "Are you sure want to chat with the selected user?",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: AIColors.white,
                          ),
                        ),
                        const SizedBox(height: 24.0),
                        TextFillButton(
                          onTap: () => Navigator.of(context).pop(true),
                          text: 'Create',
                          color: AIColors.pink,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );

          if (dialog != true) return;

          var room = RoomModel(
            uid: user?.uid,
            uids: [user?.uid, chatUser.uid],
            content: '${user?.firstName} have created a room',
          );
          logger.d(room.toJson());
          await roomService.createRoom(room);
          existedRoom = await roomService.getRoomByChatUesr(uid: chatUser.uid!);
        }
      } catch (e) {
        logger.e(e);
        setError(e);
      } finally {
        notifyListeners();
      }
    }());

    if (hasError) {
      AIHelpers.showToast(msg: modelError.toString());
    } else {
      if (existedRoom != null) {
        await Routers.goToMessagePage(
          context,
          MessagePageData(room: existedRoom!, chatUser: chatUser),
        );
      }

      fetchData();
    }
  }
}
