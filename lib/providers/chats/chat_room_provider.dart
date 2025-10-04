import 'package:flutter/material.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

class CreateRoomProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  Future<void> init(BuildContext context) async {
    this.context = context;
    getUsers();
  }

  String key = '';

  final List<UserModel> _users = [];
  List<UserModel> get users => _users;

  Future<void> searchUsers() async {
    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        _users.clear();

        var keyUsers = await userService.findUsersByKey(key);
        for (var user in keyUsers) {
          if (user != null) {
            _users.add(user);
          }
        }
        logger.d(_users.length);
      } catch (e) {
        logger.e(e);
        setError(e);
      } finally {
        notifyListeners();
      }
    }());
  }

  Future<void> getUsers() async {
    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        _users.clear();

        var keyUsers = await userService.getAllUsers();
        for (var user in keyUsers) {
          if (user != null) {
            _users.add(user);
          }
        }
        logger.d(_users.length);
      } catch (e) {
        logger.e(e);
        setError(e);
      } finally {
        notifyListeners();
      }
    }());
  }

  bool _isCreatingRoom = false;
  bool get isCreatingRoom => _isCreatingRoom;
  set isCreatingRoom(bool flag) {
    _isCreatingRoom = flag;
    notifyListeners();
  }

  Future<void> onCreateRoom(UserModel user) async {
    if (isBusy) return;
    clearErrors();
    const gradient = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Color(0xFFF30C6C), // pink
        Color(0xFFC739EB), // purple
      ],
    );

    isCreatingRoom = true;
    await runBusyFuture(() async {
      try {
        var existedRoom = await roomService.getRoomByChatUesr(
          id: user.id ?? '',
        );
        if (existedRoom != null) {
          AIHelpers.showToast(msg: 'You already created user\'s chat.');
        } else {
          var room = RoomModel(
            userId: AuthHelper.user?.id,
            userIds: [AuthHelper.user?.id, user.id],
            content: '${AuthHelper.user?.firstName} have created a room',
            updateDate: DateTime.now(),
            timestamp: DateTime.now(),
          );
          await roomService.createRoom(room);
          AIHelpers.showToast(msg: "Successfully Create Room!");
        }
        Navigator.of(context).pop();
      } catch (e) {
        logger.e(e);
        setError(e);
      } finally {
        isCreatingRoom = false;
      }
    }());

    if (hasError) {
      AIHelpers.showToast(msg: modelError.toString());
    }
  }
}
