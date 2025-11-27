import 'package:flutter/material.dart';

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

  late ChatRoomWithSettings _room;
  ChatRoomWithSettings get room => _room;
  set room(ChatRoomWithSettings model) {
    _room = model;
    notifyListeners();
  }

  int _unreadMsgCnt = 0;
  int get unreadMsgCnt => _unreadMsgCnt;
  set unreadMsgCnt(int s) {
    _unreadMsgCnt = s;
    notifyListeners();
  }

  bool _isTyping = false;
  bool get isTyping => _isTyping;
  set isTyping(bool f) {
    _isTyping = f;
    notifyListeners();
  }

  bool _archived = false;
  bool get archived => _archived;
  set archived(bool a) {
    archived = a;
    notifyListeners();
  } 

  Future<void> init(BuildContext context, {required ChatRoomWithSettings model}) async {
    this.context = context;
    room = model;

    fetchUser();

    final roomId = room.id;
    if (roomId.isNotEmpty) {
      getUnreadMessageCount();
      messageService.getTypingStatus(roomId).listen((data) {
        // Find the other user's ID (not the current user)
        String? chatUserId;
        final currentUserId = user?.id;
        final userIds = room.chatroom.userIds ?? [];
        
        if (userIds.isNotEmpty) {
          for (var id in userIds) {
            if (id != null && id != currentUserId && id.isNotEmpty) {
              chatUserId = id;
              break;
            }
          }
        }
        
        if (chatUserId == null || chatUserId.isEmpty) {
          if (room.chatroom.userId != null && 
              room.chatroom.userId != currentUserId) {
            chatUserId = room.chatroom.userId;
          }
        }
        
        if (chatUserId != null) {
          isTyping = data[chatUserId] ?? false;
        }
      });
    }
  }

  Future<void> fetchUser() async {
    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        // Find the other user's ID (not the current user)
        String? chatUserId;
        final currentUserId = user?.id;
        final userIds = room.chatroom.userIds ?? [];
        
        // First, try to find the other user in userIds array
        if (userIds.isNotEmpty) {
          for (var id in userIds) {
            if (id != null && id != currentUserId && id.isNotEmpty) {
              chatUserId = id;
              break;
            }
          }
        }
        
        // Fallback: if not found in userIds, use room.userId if it's different from current user
        if (chatUserId == null || chatUserId.isEmpty) {
          if (room.chatroom.userId != null && 
              room.chatroom.userId != currentUserId) {
            chatUserId = room.chatroom.userId;
          }
        }
        
        // Final fallback: if still null, try userIds[0] or userIds[1]
        if (chatUserId == null || chatUserId.isEmpty) {
          if (userIds.isNotEmpty) {
            chatUserId = userIds.firstWhere(
              (id) => id != null && id != currentUserId && id.isNotEmpty,
              orElse: () => userIds.first,
            );
          }
        }
        
        if (chatUserId == null || chatUserId.isEmpty) {
          setError('Unable to determine chat user.');
          return;
        }
        
        chatUser = await userService.getUser(chatUserId);
        if (chatUser == null) {
          setError('Firebase Error! Please try again later.');
        } else {
          userService.getUserStream(chatUser!.id!).listen((doc) {
            var json = doc.data();
            if (json != null) {
              json['id'] = doc.id;
              chatUser = UserModel.fromJson(json);
            }
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
      AIHelpers.showToast(msg: modelError.toString());
    }
  }

  Future<void> getUnreadMessageCount() async {
    try {
      final roomId = room.id;
      if (roomId.isNotEmpty) {
        unreadMsgCnt = await messageService.getUnreadMessageCount(roomId);
      }
    } catch (e) {
      logger.e(e);
    } finally {
      notifyListeners();
    }
  }

  Future<void> archiveChat() async {
    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        logger.d("This is rooms set: ${<String>{room.chatroom.id ?? ""}}");
        await roomService.archive(AuthHelper.user?.id ?? '', <String>{room.chatroom.id ?? ""});
        AIHelpers.showToast(msg: 'Chat archived ${room.chatroom.id}');
      } catch (e) {
        setError(e);
        logger.e(e);
      }
    }());

    if (hasError) {
      AIHelpers.showToast(msg: modelError.toString());
    }
  }

  Future<void> unArchiveChat() async {
    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        await roomService.unArchive(AuthHelper.user?.id ?? '', <String>{room.chatroom.id ?? ""});
        AIHelpers.showToast(msg: 'Chat unarchived ${room.chatroom.id}');
      } catch (e) {
        setError(e);
        logger.e(e);
      }
    }());

    if (hasError) {
      AIHelpers.showToast(msg: modelError.toString());
    }
  }
}