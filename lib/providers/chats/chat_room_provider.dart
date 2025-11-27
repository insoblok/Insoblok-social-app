import 'package:flutter/material.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

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

  void updateSearchKey(String searchKey) {
    key = searchKey;
    if (searchKey.isEmpty) {
      getUsers();
    } else {
      searchUsers();
    }
  }

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
    if (isBusy || isCreatingRoom) return;

    // Validate user ID
    if (user.id == null || user.id!.isEmpty) {
      AIHelpers.showToast(msg: 'Invalid user selected.');
      return;
    }

    clearErrors();
    isCreatingRoom = true;

    try {
      await runBusyFuture(() async {
        try {
          var existedRoom = await roomService.getRoomByChatUser(id: user.id!);
          if (existedRoom != null) {
            AIHelpers.showToast(msg: 'You already have a chat with this user.');
            return;
          }

          var currentUser = AuthHelper.user;
          if (currentUser?.id == null) {
            throw Exception('Current user not found. Please log in again.');
          }

          final currentUserId = currentUser!.id!;
          var room = RoomModel(
            userId: currentUserId,
            userIds: [currentUserId, user.id!],
            content: '${currentUser.firstName ?? 'User'} created a room',
            updatedAt: DateTime.now(),
            timestamp: DateTime.now(),
          );

          final roomId = await roomService.createRoom(room);
          if (roomId.isNotEmpty) {
            AIHelpers.showToast(msg: "Room created successfully!");

            // Wait a moment for Firestore to propagate the changes
            await Future.delayed(const Duration(milliseconds: 300));
          }

          // Pop with result to indicate room was created successfully
          Navigator.of(context).pop(roomId.isNotEmpty);
        } catch (e) {
          logger.e(e);
          setError(e);
          // Show error toast
          AIHelpers.showToast(
            msg:
                modelError?.toString() ??
                'Failed to create room. Please try again.',
          );
        }
      }());
    } finally {
      isCreatingRoom = false;
    }
  }
}
