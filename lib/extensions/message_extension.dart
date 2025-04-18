import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';
import 'package:video_player/video_player.dart';

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
        result = VideoContent(
          videoUrl: url ?? 'https://',
        );
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

class VideoContent extends StatefulWidget {
  final String videoUrl;

  const VideoContent({
    super.key,
    required this.videoUrl,
  });

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
    _videoPlayerController.dispose();
    _chewieController.dispose();
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
                : Center(
                    child: Loader(color: Colors.white),
                  ),
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
