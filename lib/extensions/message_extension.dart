import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:chewie/chewie.dart';
import 'package:gif_view/gif_view.dart';
import 'package:video_player/video_player.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

extension MessageModelExt on MessageModel {
  Widget item(BuildContext context, {required UserModel chatUser}) {
    final isMe = senderId == AuthHelper.user?.uid;
    Widget result = Container();
    var type = MessageModelTypeExt.fromString(this.type ?? 'text');
    switch (type) {
      case MessageModelType.text:
        result = _textContent(context);
      case MessageModelType.image:
        result = _imageContent();
      case MessageModelType.video:
        result = VideoContent(videoUrl: url ?? 'https://');
      case MessageModelType.gif:
        result = _gifContent();
      case MessageModelType.audio:
        result = Container();
      case MessageModelType.paid:
        result = _paidContent();
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
                  color: AIColors.blue.withAlpha(196),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    result,
                    SizedBox(height: 4),
                    Text(
                      messageTime,
                      style: TextStyle(fontSize: 9, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
          if (isMe) ...{
            AuthHelper.user!.avatarStatusView(
              width: 32,
              height: 32,
              borderWidth: 2.0,
              textSize: 14.0,
              statusSize: 10.0,
            ),
          },
        ],
      ),
    );
  }

  Widget _textContent(BuildContext context) {
    final isMe = senderId == AuthHelper.user?.uid;
    return Text(
      '$content',
      style:
          isMe
              ? TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.normal,
                color: AIColors.white,
              )
              : Theme.of(context).textTheme.bodyMedium,
    );
  }

  Widget _imageContent() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: AIImage(url, width: 180.0, height: 240.0),
    );
  }

  Widget _paidContent() {
    var coin = CoinModel.fromJson(jsonDecode(content ?? '{}'));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Transaction',
          style: TextStyle(fontSize: 11.0, color: Colors.white),
        ),
        const SizedBox(height: 8.0),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AIImage(AIImages.icEthereumGold, width: 36.0, height: 36.0),
            const SizedBox(width: 8.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${coin.amount} ${coin.unit?.toUpperCase()}',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '0.0016 USD',
                  style: TextStyle(fontSize: 11.0, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        Text(
          'Paid',
          style: TextStyle(
            fontSize: 11.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _gifContent() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: GifView.network(url ?? 'https://', width: 180.0),
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

enum MessageModelType { text, image, video, gif, audio, paid }

extension MessageModelTypeExt on MessageModelType {
  static MessageModelType fromString(String data) {
    switch (data) {
      case 'text':
        return MessageModelType.text;
      case 'image':
        return MessageModelType.image;
      case 'video':
        return MessageModelType.video;
      case 'audio':
        return MessageModelType.audio;
      case 'paid':
        return MessageModelType.paid;
      case 'gif':
        return MessageModelType.gif;
    }
    return MessageModelType.text;
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
      'uid': uid,
      'uids': (uids),
      'content': content,
      'status_sender': statusSender,
      'status_receiver': statusReceiver,
      'update_date': updateDate?.toUtc().toIso8601String(),
      'timestamp': timestamp?.toUtc().toIso8601String(),
    };
    result.removeWhere((k, v) => v == null);
    return result;
  }
}
