import 'dart:io';
import 'dart:async';

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
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;

  bool _initError = false;
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    _setupControllers(widget.videoUrl);
  }

  @override
  void didUpdateWidget(covariant VideoView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl) {
      _disposeControllers();
      _setupControllers(widget.videoUrl);
    }
  }

  Future<void> _setupControllers(String url) async {
    _initError = false;
    setState(() {});

    try {
      final controller = await _tryInitController(url, maxAttempts: 4);
      if (controller == null) {
        if (!_disposed) setState(() => _initError = true);
        return;
      }

      if (_disposed) {
        await controller.dispose();
        return;
      }

      final ratio = controller.value.aspectRatio;
      _videoPlayerController = controller;
      _chewieController = ChewieController(
        videoPlayerController: controller,
        aspectRatio: (ratio.isFinite && ratio > 0) ? ratio : 16 / 9,
        showControls: false,
        autoPlay: false,
        looping: false,
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.red,
          handleColor: Colors.red,
          backgroundColor: Colors.grey,
          bufferedColor: Colors.lightGreen,
        ),
      );

      if (mounted) setState(() => _initError = false);
    } catch (e, s) {
      logger.e('Video init failed for "$url": $e\n$s');
      if (mounted) setState(() => _initError = true);
    }
  }

  /// Tries to create+initialize a controller with retries & backoff.
  Future<VideoPlayerController?> _tryInitController(
    String url, {
    int maxAttempts = 3,
  }) async {
    Duration backoff = const Duration(milliseconds: 150);

    for (int attempt = 1; attempt <= maxAttempts; attempt++) {
      if (_disposed) return null;

      VideoPlayerController? c;
      try {
        c = _createControllerFor(url);

        // If it's a file path, wait until the file looks ready.
        if (_isLocalFilePath(url)) {
          final ready = await _waitForFileReady(url,
              timeout: const Duration(seconds: 2));
          if (!ready) {
            throw Exception('Media file not ready yet');
          }
        }

        // Small grace period helps right after camera/AR writes the file.
        await Future.delayed(const Duration(milliseconds: 60));

        await c.initialize();
        return c; // success
      } catch (e) {
        logger.w('Video init attempt $attempt/$maxAttempts failed: $e');
        try {
          await c?.dispose();
        } catch (_) {}

        if (attempt == maxAttempts) break;

        // exponential-ish backoff
        await Future.delayed(backoff);
        backoff *= 2;
      }
    }
    return null;
  }

  VideoPlayerController _createControllerFor(String url) {
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return VideoPlayerController.networkUrl(Uri.parse(url));
    }
    if (url.startsWith('content://')) {
      // Requires video_player >= 2.4.0
      return VideoPlayerController.contentUri(Uri.parse(url));
    }
    if (url.startsWith('file://')) {
      return VideoPlayerController.file(File.fromUri(Uri.parse(url)));
    }
    // Plain filesystem path
    return VideoPlayerController.file(File(url));
  }

  bool _isLocalFilePath(String url) {
    if (url.startsWith('http')) return false;
    if (url.startsWith('content://')) return false; // handled by content resolver
    return true; // file:// or plain path
  }

  /// Waits until a local file exists, is non-zero, and its size stabilizes.
  Future<bool> _waitForFileReady(String path,
      {Duration timeout = const Duration(seconds: 2)}) async {
    final deadline = DateTime.now().add(timeout);
    int? lastSize;

    while (DateTime.now().isBefore(deadline)) {
      try {
        final f = path.startsWith('file://')
            ? File.fromUri(Uri.parse(path))
            : File(path);

        if (await f.exists()) {
          final len = await f.length();
          if (len > 0) {
            if (lastSize != null && lastSize == len) {
              return true; // stable size
            }
            lastSize = len;
          }
        }
      } catch (_) {
        // ignore; retry
      }
      await Future.delayed(const Duration(milliseconds: 120));
    }
    return false;
  }

  void _disposeControllers() {
    try {
      _chewieController?.dispose();
    } catch (_) {}
    _chewieController = null;

    try {
      _videoPlayerController?.dispose();
    } catch (_) {}
    _videoPlayerController = null;
  }

  @override
  void dispose() {
    _disposed = true;
    _disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isReady = _videoPlayerController?.value.isInitialized == true &&
        _chewieController != null &&
        !_initError;

    return ClipRRect(
      borderRadius: BorderRadius.circular(6.0),
      child: SizedBox(
        width: widget.width ?? 180.0,
        height: widget.height ?? 135.0,
        child: Stack(
          children: [
            if (isReady)
              Chewie(controller: _chewieController!)
            else
              Center(
                child: _initError
                    ? Text(
                        'Can’t load video',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                      )
                    : const CircularProgressIndicator(strokeWidth: 2),
              ),
            if (isReady)
              Align(
                alignment: Alignment.center,
                child: IconButton(
                  onPressed: () {
                    final vc = _videoPlayerController!;
                    setState(() {
                      if (vc.value.isPlaying) {
                        vc.pause();
                      } else {
                        vc.play();
                      }
                    });
                  },
                  icon: Icon(
                    (_videoPlayerController?.value.isPlaying ?? false)
                        ? Icons.pause_circle
                        : Icons.play_circle,
                    color: Colors.white,
                    size: 32.0,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
