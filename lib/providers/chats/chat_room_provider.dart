import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:insoblok/generated/l10n.dart';
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

        var keyUsers = await FirebaseHelper.findUsersByKey(key);
        _users.addAll(keyUsers);
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        S.current.create_room,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24.0),
                  Text(
                    S.current.create_room_confirm,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  TextFillButton(
                    onTap: () => Navigator.of(context).pop(true),
                    text: 'Create',
                    color: AIColors.blue,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (dialog != true) return;

    isCreatingRoom = true;
    await runBusyFuture(() async {
      try {
        var room = RoomModel(
          relatedId: '${AuthHelper.user?.uid}:${user.uid}',
          senderId: AuthHelper.user?.uid,
          receiverId: user.uid,
          content:
              '${AuthHelper.user?.firstName} ${S.current.create_room_message}',
        );
        await FirebaseHelper.createRoom(room);
      } catch (e) {
        logger.e(e);
        setError(e);
      } finally {
        isCreatingRoom = false;
      }
    }());

    if (hasError) {
      Fluttertoast.showToast(msg: modelError.toString());
    } else {
      Fluttertoast.showToast(msg: S.current.create_room_alert);
      Navigator.of(context).pop();
    }
  }
}
