import 'package:flutter/material.dart';
import 'package:insoblok/extensions/extensions.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/pages/pages.dart';
import 'package:insoblok/routers/router.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';
import 'package:insoblok/locator.dart';

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

  final Web3Service _web3Service = locator<Web3Service>();

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
        if ((room.userIds?.isNotEmpty ?? false) &&
            room.userIds!.contains(AuthHelper.user?.id)) {
          logger.d(room.id);
          _rooms.add(room);
        }
      }
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
      List<String?> userIds = [];
      for (var room in _rooms) {
        userIds.addAll(room.userIds ?? []);
      }
      for (var user in keyUsers) {
        if (user != null) {
          if (userIds.contains(user.id)) continue;
          newUsers.add(RoomModel(userId: user.id));
        }
      }
      _rooms.addAll(newUsers);
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
        existedRoom = await roomService.getRoomByChatUesr(id: chatUser.id!);
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
            userId: user?.id,
            userIds: [user?.id, chatUser.id],
            content: '${user?.fullName} have created a room',
            updateDate: DateTime.now(),
            timestamp: DateTime.now(),
          );
          await roomService.createRoom(room);
          existedRoom = await roomService.getRoomByChatUesr(id: chatUser.id!);
          messageService.setInitialTypeStatus(existedRoom!.id!, chatUser.id!);
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
        _web3Service.chatRoom = existedRoom ?? RoomModel();
        _web3Service.chatUser = chatUser;
        await Routers.goToMessagePage(
          context,
          MessagePageData(room: existedRoom!, chatUser: chatUser),
        );
      }

      fetchData();
    }
  }
}
