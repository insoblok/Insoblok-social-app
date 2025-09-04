import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:insoblok/services/services.dart';
import 'package:video_player/video_player.dart';

class VideoView extends StatefulWidget {
  final String videoUrl;
  final double? width;
  final double? height;
  final double? loaderSize;

  const VideoView({
    super.key,
    required this.videoUrl,
    this.width,
    this.height,
    this.loaderSize,
  });

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  bool isPlaying = false;

  @override
  void initState() {
    super.initState();

    if (widget.videoUrl.contains('http')) {
      _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl),
      );
    } else {
      _videoPlayerController = VideoPlayerController.file(
        File(widget.videoUrl),
      );
    }
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
        width: widget.width ?? 180.0,
        height: widget.height ?? 135.0,
        child: Stack(
          children: [
            _videoPlayerController.value.isInitialized
                ? Chewie(controller: _chewieController)
                : Center(
                  // child: Loader(
                  //   size: widget.loaderSize ?? 60,
                  //   color: Colors.white,
                  // ),
                  child: Text(
                    'Attached',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
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
