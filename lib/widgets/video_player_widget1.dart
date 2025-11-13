import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:insoblok/services/services.dart';

// Global cache for video controllers
final Map<String, VideoPlayerController> _videoControllerCache = {};

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

class _VideoPlayerState extends State<VideoPlayerWidget> with AutomaticKeepAliveClientMixin {
  VideoPlayerController? _controller;
  bool _initialized = false;
  bool _isPlaying = false;
  String _currentPath = "";

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initializeVideo(widget.path);
  }


  Future<void> _initializeVideo(String path) async {
    logger.d("initial value is $_initialized, $_controller");
    
    // Check if we already have a cached controller for this path
    if (_videoControllerCache.containsKey(path)) {
      _controller = _videoControllerCache[path];
      if (_controller != null && _controller!.value.isInitialized) {
        logger.d("✅ Using cached controller for path: $path");
        _currentPath = path;
        if (mounted) {
          setState(() {
            _initialized = true;
            _isPlaying = false;
          });
        }
        return;
      }
    }
    
    if (_initialized && _controller != null && _controller!.dataSource == path) {
      logger.d("✅ Already initialized with path: $path");
      return;
    }
    
    try {
      // Dispose previous controller safely only if it's not cached
      logger.d("current path is $_currentPath");
      if (_currentPath != null && _currentPath != path && !_videoControllerCache.containsKey(_currentPath)) {
        await _controller?.pause();
        await _controller?.dispose();
        _controller = null;
        _initialized = false;
        
        if (mounted) {
          setState(() {});
        }
      }

      _currentPath = path;

      // Create new controller
      VideoPlayerController? newController;
      if (path.startsWith('http')) {
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

      await newController.initialize();
      newController.setLooping(true);

      // Cache the controller
      _videoControllerCache[path] = newController;
      _controller = newController;

      if (mounted) {
        setState(() {
          _initialized = true;
          _isPlaying = false;
        });
      }
    } catch (error) {
      logger.e("⚠️ Video initialization error: $path, $error");
      if (mounted) {
        setState(() {
          _controller = null;
          _initialized = false;
        });
      }
    }
  }

  @override
  void dispose() {
    // Only dispose if not cached
    if (_controller != null && !_videoControllerCache.containsValue(_controller)) {
      _controller?.dispose();
    }
    super.dispose();
  }

  // Static method to clear cache when needed
  static void clearCache() {
    for (final controller in _videoControllerCache.values) {
      controller.dispose();
    }
    _videoControllerCache.clear();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    final size = (widget.circular)
        ? widget.radius ?? 100
        : widget.width ?? MediaQuery.of(context).size.width;

    return ClipOval(
      clipBehavior:
          widget.circular ? Clip.antiAlias : Clip.none, // fix for non-circular
      child: Container(
        width: widget.circular ? size : widget.width,
        height: widget.circular ? size : widget.height,
        decoration: BoxDecoration(
          shape: widget.circular ? BoxShape.circle : BoxShape.rectangle,
          border: Border.all(color: widget.border, width: 2),
          color: Colors.transparent,
        ),
        child: _initialized && _controller != null
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
                    Text(
                      'Loading...',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}


