import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:chewie/chewie.dart';
import 'package:gif_view/gif_view.dart';
import 'package:video_player/video_player.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/enums/enums.dart';

extension MessageModelExt on MessageModel {
  Widget item(BuildContext context, {required UserModel chatUser}) {
    final isMe = senderId == AuthHelper.user?.id;
    logger.d(
      "🎨 Rendering message - senderId: $senderId, currentUserId: ${AuthHelper.user?.id}, isMe: $isMe, type: $type, content: $content",
    );

    Widget result = Container();

    // Parse type - it might be a string or enum
    MessageType? messageType;
    if (type is MessageType) {
      messageType = type as MessageType;
    } else if (type is String) {
      messageType = MessageModelTypeExt.fromString(type as String);
    }

    logger.d("🎨 Parsed messageType: $messageType");

    switch (messageType) {
      case MessageType.text:
        result = _textContent(context);
        break;
      case MessageType.image:
        result = _imageContent();
        break;
      case MessageType.video:
        result = VideoContent(videoUrl: medias?.first ?? 'https://');
        break;
      case MessageType.gif:
        result = _gifContent();
        break;
      case MessageType.audio:
        result = Container();
        break;
      case MessageType.paid:
        result = _paidContent();
        break;
      case MessageType.file:
        result = Container();
        break;
      default:
        logger.w("⚠️ Unknown message type: $type, defaulting to text");
        result = _textContent(context);
        break;
    }

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...{
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                chatUser.avatarStatusView(
                  width: 32,
                  height: 32,
                  borderWidth: 2.0,
                  textSize: 14.0,
                  statusSize: 10.0,
                ),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width - 120.0,
                  ),
                  padding: EdgeInsets.only(left: 12.0, right: 8.0, bottom: 8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            isMe
                                ? AuthHelper.user?.fullName ?? 'test'
                                : chatUser.fullName,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          SizedBox(width: 8),
                          Text(
                            messageTime,
                            style: TextStyle(
                              fontSize: 9,
                              color: AIColors.greyTextColor,
                            ),
                          ),
                        ],
                      ),
                      result,
                    ],
                  ),
                ),
              ],
            ),
          },
          if (isMe)
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    (type == MessageType.text || type == MessageType.paid)
                        ? Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width - 120.0,
                          ),
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: AIColors.lightBlue,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onPrimary.withAlpha(96),
                                spreadRadius: 1,
                                blurRadius: 2,
                                offset: Offset(
                                  0,
                                  1,
                                ), // changes position of shadow
                              ),
                            ],
                          ),
                          child: result,
                        )
                        : result,
                    const SizedBox(height: 4),
                    Text(
                      messageTime,
                      style: TextStyle(
                        fontSize: 9,
                        color: AIColors.greyTextColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 8),
                AuthHelper.user!.avatarStatusView(
                  width: 32,
                  height: 32,
                  borderWidth: 2.0,
                  textSize: 14.0,
                  statusSize: 10.0,
                ),
              ],
            ),
          // if (isMe)
          //   ClipPath(
          //     clipper: isMe ? MessageMeClipper() : MessageChatClipper(),
          //     child: Container(
          //       constraints: BoxConstraints(
          //         maxWidth: MediaQuery.of(context).size.width - 120.0,
          //       ),
          //       padding: EdgeInsets.only(
          //         left: isMe ? 8.0 : 20.0,
          //         right: isMe ? 20.0 : 8.0,
          //         top: 8.0,
          //         bottom: 8.0,
          //       ),
          //       decoration: BoxDecoration(
          //         color: AIColors.blue.withAlpha(196),
          //         borderRadius: BorderRadius.circular(12),
          //       ),
          //       child: Column(
          //         mainAxisSize: MainAxisSize.min,
          //         crossAxisAlignment: CrossAxisAlignment.end,
          //         children: [
          //           result,
          //           SizedBox(height: 4),
          //           Text(
          //             messageTime,
          //             style: TextStyle(fontSize: 9, color: Colors.white70),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // if (isMe) ...{
          //   AuthHelper.user!.avatarStatusView(
          //     width: 32,
          //     height: 32,
          //     borderWidth: 2.0,
          //     textSize: 14.0,
          //     statusSize: 10.0,
          //   ),
          // },
        ],
      ),
    );
  }

  Widget _textContent(BuildContext context) {
    final isMe = senderId == AuthHelper.user?.id;
    return Text(
      '$content',
      style:
          isMe
              ? TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.normal,
                color: Colors.white,
              )
              : Theme.of(context).textTheme.bodyMedium,
    );
  }

  Widget _imageContent() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: AIImage(medias?.first, width: 180.0, height: 240.0),
    );
  }

  Widget _paidContent() {
    var coin = CoinModel.fromJson(jsonDecode(content ?? '{}'));
    final network = kWalletTokenList.firstWhere(
      (tk) => tk["short_name"] == coin.unit,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Transaction', style: TextStyle(fontSize: 11.0)),
        const SizedBox(height: 8.0),

        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AIImage(network["icon"], width: 36.0, height: 36.0),
            const SizedBox(width: 8.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${coin.amount} ${coin.unit?.toUpperCase().replaceAll('ETHERUNIT.', '')}',
                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                ),
                // Text('0.0016 USD', style: TextStyle(fontSize: 11.0)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        // Image(image: NetworkImage(AIImages.icSuccess), width: 36.0, height: 36.0, fit: BoxFit.cover),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GifView.asset(
              AIImages.icSuccess,
              width: 36.0,
              height: 36.0,
              loop: false,
              autoPlay: true,
            ),
            Text('Successfully Sent'),
          ],
        ),
      ],
    );
  }

  Widget _gifContent() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: GifView.network(medias?.first ?? 'https://', width: 180.0),
    );
  }

  String get messageTime {
    try {
      if (timestamp != null) {
        return kDateHMFormatter.format(timestamp!);
      }
    } catch (e) {
      logger.e(e);
    }
    return kDateHMFormatter.format(DateTime.now());
  }
}

extension MessageModelTypeExt on MessageType {
  static MessageType fromString(String data) {
    switch (data) {
      case 'text':
        return MessageType.text;
      case 'image':
        return MessageType.image;
      case 'video':
        return MessageType.video;
      case 'audio':
        return MessageType.audio;
      case 'paid':
        return MessageType.paid;
      case 'gif':
        return MessageType.gif;
    }
    return MessageType.text;
  }
}

class VideoContent extends StatefulWidget {
  final String videoUrl;

  const VideoContent({super.key, required this.videoUrl});

  @override
  State<VideoContent> createState() => _VideoContentState();
}

class _VideoContentState extends State<VideoContent> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  bool isPlaying = false;

  @override
  void initState() {
    super.initState();

    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
    );
    _videoPlayerController.addListener(() {
      if (_videoPlayerController.value.isCompleted) {
        setState(() {
          isPlaying = false;
          _videoPlayerController.seekTo(Duration(milliseconds: 0));
        });
      }
    });
    _videoPlayerController.initialize().then((data) {
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        aspectRatio: _videoPlayerController.value.aspectRatio,
        showControls: false,
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.red,
          handleColor: Colors.red,
          backgroundColor: Colors.grey,
          bufferedColor: Colors.lightGreen,
        ),
      );

      setState(() {});
    });
  }

  @override
  void dispose() {
    if (_videoPlayerController.value.isInitialized) {
      _videoPlayerController.dispose();
      _chewieController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6.0),
      child: SizedBox(
        width: 180.0,
        height: 135.0,
        child: Stack(
          children: [
            _videoPlayerController.value.isInitialized
                ? Chewie(controller: _chewieController)
                : Center(child: Loader(size: 60, color: Colors.white)),
            if (_videoPlayerController.value.isInitialized) ...{
              Align(
                alignment: Alignment.center,
                child: IconButton(
                  onPressed: () {
                    if (isPlaying) {
                      _videoPlayerController.pause();
                    } else {
                      _videoPlayerController.play();
                    }
                    setState(() {
                      isPlaying = !isPlaying;
                    });
                  },
                  icon: Icon(
                    isPlaying ? Icons.pause_circle : Icons.play_circle,
                    color: Colors.white,
                    size: 32.0,
                  ),
                ),
              ),
            },
          ],
        ),
      ),
    );
  }
}

extension RoomModelExt on RoomModel {
  Map<String, dynamic> toMap() {
    Map<String, dynamic> result = {
      'user_id': userId,
      'user_ids': (userIds),
      'content': content,
      'status_sender': statusSender,
      'status_receiver': statusReceiver,
      'is_group': isGroup,
      'updated_at': updatedAt?.toUtc().toIso8601String(),
      'timestamp': timestamp?.toUtc().toIso8601String(),
    };
    result.removeWhere((k, v) => v == null);
    return result;
  }
}
