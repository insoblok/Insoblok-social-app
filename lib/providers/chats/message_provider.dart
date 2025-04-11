import 'package:flutter/material.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/pages/pages.dart';
import 'package:insoblok/services/services.dart';
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

  final _messageService = MessageService();
  MessageService get messageService => _messageService;

  final List<MessageModel> _messages = [];
  List<MessageModel> get messages => _messages;
  set messages(List<MessageModel> data) {
    _messages.clear();
    _messages.addAll(data);
    notifyListeners();
  }

  var controller = TextEditingController();

  Future<void> init(
    BuildContext context, {
    required MessagePageData data,
  }) async {
    this.context = context;
    room = data.room;
    chatUser = data.chatUser;

    messageService.getMessages(room.id!).listen((messages) {
      this.messages = messages;
    });
  }

  String? _content;
  String? get content => _content;
  set content(String? s) {
    _content = s;
    notifyListeners();
  }

  void sendMessage() async {
    if (content?.isNotEmpty ?? false) {
      try {
        await messageService.sendMessage(
          chatRoomId: room.id!,
          text: content!,
        );
        // scrollToBottom();
        controller.text = '';
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send message: $e')),
        );
      } finally {
        notifyListeners();
      }
    }
  }

  Widget buildMessageItem(MessageModel message) {
    final isMe = message.senderId == user?.uid;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe
              ? Theme.of(context).primaryColor.withAlpha(204)
              : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMe)
              Text(
                '${message.senderName}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isMe ? Colors.white : Colors.black,
                ),
              ),
            // if (message.url != null)
            //   Padding(
            //     padding: EdgeInsets.only(bottom: 8),
            //     child: ClipRRect(
            //       borderRadius: BorderRadius.circular(8),
            //       child: Image.network(
            //         message.imageUrl!,
            //         width: 200,
            //         height: 200,
            //         fit: BoxFit.cover,
            //       ),
            //     ),
            //   ),
            Text(
              '${message.content}',
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 4),
            Text(
              message.messageTime,
              style: TextStyle(
                fontSize: 10,
                color: isMe ? Colors.white70 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
