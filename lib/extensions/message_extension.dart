import 'package:flutter/material.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

extension MessageModelExt on MessageModel {
  Widget item(
    BuildContext context, {
    required UserModel chatUser,
  }) {
    final isMe = senderId == AuthHelper.user?.uid;
    Widget result = Container();
    var type = MessageModelTypeExt.fromString(this.type ?? 'text');
    switch (type) {
      case MessageModelType.text:
        result = _textContent();
      case MessageModelType.image:
        result = _imageContent();
      case MessageModelType.video:
        result = Container();
      case MessageModelType.audio:
        result = Container();
      case MessageModelType.paid:
        result = Container();
    }

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...{
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: AIImage(
                chatUser.avatar,
                width: 32.0,
                height: 32.0,
              ),
            ),
          },
          ClipPath(
            clipper: isMe ? MessageMeClipper() : MessageChatClipper(),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width - 120.0,
              ),
              padding: EdgeInsets.only(
                left: isMe ? 8.0 : 20.0,
                right: isMe ? 20.0 : 8.0,
                top: 8.0,
                bottom: 8.0,
              ),
              decoration: BoxDecoration(
                color: isMe
                    ? AIColors.blue.withAlpha(204)
                    : AIColors.appBar.withAlpha(204),
                borderRadius: BorderRadius.circular(12),
              ),
              child: result,
            ),
          ),
          if (isMe) ...{
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: AIImage(
                AuthHelper.user?.avatar,
                width: 32.0,
                height: 32.0,
              ),
            ),
          },
        ],
      ),
    );
  }

  Widget _textContent() {
    final isMe = senderId == AuthHelper.user?.uid;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMe)
              Text(
                '$senderName',
                style: TextStyle(
                  fontSize: 10.0,
                  color: Colors.white,
                ),
              ),
            Text(
              '$content',
              style: TextStyle(
                fontSize: 13.0,
                color: Colors.white,
                fontWeight: isMe ? FontWeight.w400 : FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        Text(
          messageTime,
          style: TextStyle(
            fontSize: 9,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _imageContent() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6.0),
      child: AIImage(
        url,
        width: 180.0,
        height: 135.0,
      ),
    );
  }
}
