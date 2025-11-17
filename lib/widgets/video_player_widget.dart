import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:insoblok/services/services.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String path;
  final Color border;
  final bool circular;
  final double? radius;
  final double? width;
  final double? height;

  const VideoPlayerWidget({
    super.key,
    required this.path,
    required this.border,
    this.circular = false,
    this.radius,
    this.width,
    this.height,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayerWidget> {
  VideoPlayerController? _controller;
  bool _initialized = false;
  bool _isPlaying = false;
  bool validate = false;

  int attempt = 0;
  // @override
  // bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initializeVideo(widget.path);
  }

  @override
  void didUpdateWidget(VideoPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.path != widget.path) {
      // 👇 Reinitialize safely when path changes
      _reinitVideo(widget.path);
    }
  }

  Future<void> _reinitVideo(String path) async {
    await _controller?.dispose();
    await _initController(path);
  }

  Future<void> _initController(String path) async {
    _controller = VideoPlayerController.file(File(path));
    await _controller!.initialize();
    setState(() {});
    _controller!.play();
  }

  Future<bool> validateVideoFile(String path) async {
    if (path.isEmpty) return false;

    // Network URLs (http/https) are always valid - we can't check existence locally
    if (path.startsWith('http://') || path.startsWith('https://')) {
      logger.d("Network video URL detected: $path");
      return true;
    }

    // Asset paths are always valid
    if (path.contains("assets")) return true;

    // For local file paths, check if file exists
    try {
      final file = File(path);
      if (!await file.exists()) {
        logger.d("Video file does not exist: $path");
        return false;
      }

      final fileSize = await file.length();
      if (fileSize == 0) {
        logger.d("Video file is empty: $path");
        return false;
      }

      return true;
    } catch (e) {
      logger.e("Error validating video file $path: $e");
      return false;
    }
  }

  Future<void> _initializeVideo(String path) async {
    // For network URLs, add a delay to allow video to be fully available
    if (path.startsWith('http://') || path.startsWith('https://')) {
      await Future.delayed(const Duration(seconds: 2));
    } else {
      await Future.delayed(const Duration(milliseconds: 1500));
    }

    int maxAttempts = 3;
    int attempt = 0;

    while (attempt < maxAttempts) {
      attempt++;
      try {
        // Dispose previous controller safely
        validate = await validateVideoFile(path);

        VideoPlayerController? newController;
        if (path.startsWith('http://') || path.startsWith('https://')) {
          logger.d(
            'Initializing network video: $path (attempt $attempt/$maxAttempts)',
          );
          newController = VideoPlayerController.networkUrl(Uri.parse(path));
        } else if (path.contains('asset')) {
          newController = VideoPlayerController.asset(path);
        } else {
          final file = File(path);
          if (!await file.exists()) {
            logger.e("❌ Video file not found: $path");
            if (mounted) {
              setState(() => _initialized = false);
            }
            return;
          }
          newController = VideoPlayerController.file(file);
        }

        // Dispose old controller if exists
        await _controller?.dispose();
        _controller = newController;

        await _controller!.initialize();

        _controller!.setLooping(true);

        if (mounted) {
          setState(() {
            _initialized = true;
            _isPlaying = false;
          });
        }

        logger.d('✅ Video initialized successfully: $path');
        return; // Success - exit retry loop
      } catch (error) {
        logger.e(
          "⚠️ Video initialization error (attempt $attempt/$maxAttempts): $path, $error",
        );

        // Dispose failed controller
        try {
          await _controller?.dispose();
          _controller = null;
        } catch (_) {}

        if (attempt < maxAttempts) {
          // Wait before retry with exponential backoff
          final delay = Duration(milliseconds: 1000 * attempt);
          logger.d(
            'Retrying video initialization in ${delay.inMilliseconds}ms...',
          );
          await Future.delayed(delay);
        } else {
          // All attempts failed
          if (mounted) {
            setState(() {
              _controller = null;
              _initialized = false;
            });
          }
          logger.e('❌ Failed to initialize video after $maxAttempts attempts');
        }
      }
    }
  }

  @override
  void dispose() {
    _controller?.pause();
    _controller?.dispose();
    _controller = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size =
        (widget.circular)
            ? widget.radius ?? 100
            : widget.width ?? MediaQuery.of(context).size.width;


    return ClipOval(
      clipBehavior:
          widget.circular ? Clip.antiAlias : Clip.none, // fix for non-circular
      child: Container(
        width: widget.circular ? size : widget.width,
        height: widget.circular ? size : widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size / 2),
          color: Colors.transparent,
        ),
        child:
            _initialized && validate && _controller != null
                ? Stack(
                  alignment: Alignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: _controller!.value.aspectRatio,
                      child: VideoPlayer(_controller!),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_isPlaying) {
                          _controller!.pause();
                        } else {
                          _controller!.play();
                        }
                        setState(() => _isPlaying = !_isPlaying);
                      },
                      child: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white.withOpacity(0.8),
                        size: 24,
                      ),
                    ),
                  ],
                )
                : const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(strokeWidth: 2),
                      SizedBox(height: 8),
                      Text('Loading...', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
      ),
    );

    // Apply ClipOval only for circular videos
    if (widget.circular) {
      return ClipOval(clipBehavior: Clip.antiAlias, child: content);
    } else {
      return ClipRRect(borderRadius: BorderRadius.circular(0), child: content);
    }
  }
}
