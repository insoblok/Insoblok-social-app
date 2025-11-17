import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:insoblok/services/logger_service.dart';
import 'package:stacked/stacked.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/widgets/widgets.dart';
import 'package:video_player/video_player.dart';
import 'package:insoblok/services/services.dart';

class ReactionsPage extends StatelessWidget {
  final StoryModel story;

  const ReactionsPage({super.key, required this.story});

  bool _isVideo(String url) {
    if (url.isEmpty) return false;
    final u = url.toLowerCase();
    // Check for Cloudinary video URLs (most common case for reactions)
    if (u.contains('cloudinary.com')) {
      // Cloudinary video URLs contain '/video/' or 'video/upload'
      return u.contains('/video/') || u.contains('video/upload');
    }
    // Check for Vimeo
    if (u.contains('vimeo.com')) {
      return true;
    }
    // Check for video file extensions
    return RegExp(
      r'\.(mp4|mov|m3u8|webm|avi|flv|wmv)(\?|$|/)',
      caseSensitive: false,
    ).hasMatch(u);
  }

  // Transform Cloudinary URL to ensure it's playable
  String _ensurePlayableUrl(String url) {
    if (url.isEmpty) return url;

    // Remove any whitespace from the URL (fixes issues with spaces in path)
    String processedUrl = url.trim().replaceAll(RegExp(r'\s+'), '');

    // Convert HTTP to HTTPS first
    if (processedUrl.startsWith('http://')) {
      processedUrl = processedUrl.replaceFirst('http://', 'https://');
    }

    final u = processedUrl.toLowerCase();

    // If it's a Cloudinary video URL without extension, add .mp4
    if (u.contains('cloudinary.com') &&
        (u.contains('/video/') || u.contains('video/upload')) &&
        !RegExp(
          r'\.(mp4|mov|webm|avi)(\?|$|/)',
          caseSensitive: false,
        ).hasMatch(u)) {
      // Add .mp4 extension if not present
      return processedUrl.endsWith('/')
          ? '${processedUrl}mp4'
          : '$processedUrl.mp4';
    }

    return processedUrl;
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ReactionsProvider>.reactive(
      viewModelBuilder: () => ReactionsProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context, story: story),
      builder: (context, viewModel, _) {
        final hasReactions = viewModel.reactions.isNotEmpty;

        // Debug logging
        logger.d("ReactionsPage - hasReactions: $hasReactions");
        logger.d(
          "ReactionsPage - reactions count: ${viewModel.reactions.length}",
        );
        if (viewModel.reactions.isNotEmpty) {
          logger.d("ReactionsPage - reactions: ${viewModel.reactions}");
        }

        return Scaffold(
          body: Stack(
            children: [
              AppBackgroundView(
                child:
                    hasReactions
                        ? CustomScrollView(
                          controller: viewModel.controller,
                          physics: const BouncingScrollPhysics(),
                          slivers: [
                            SliverAppBar(
                              pinned: true,
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              leading: IconButton(
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                                onPressed: () => Navigator.pop(context),
                              ),
                              centerTitle: true,
                              title: const Text(
                                "Reactions",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SliverPadding(
                              padding: const EdgeInsets.all(12.0),
                              sliver: SliverGrid(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 8,
                                      mainAxisSpacing: 8,
                                    ),
                                delegate: SliverChildBuilderDelegate((
                                  context,
                                  index,
                                ) {
                                  // Clean the URL first (remove any whitespace that might cause issues)
                                  final rawUrl = viewModel.reactions[index];
                                  final mediaUrl = rawUrl.trim().replaceAll(
                                    RegExp(r'\s+'),
                                    '',
                                  );
                                  final isVideo = _isVideo(mediaUrl);
                                  final playableUrl =
                                      isVideo
                                          ? _ensurePlayableUrl(mediaUrl)
                                          : mediaUrl;
                                  final isSelected = viewModel.isSelected(
                                    mediaUrl,
                                  );

                                  // Debug logging for each item
                                  logger.d(
                                    "Reaction $index: $mediaUrl, isVideo: $isVideo, playableUrl: $playableUrl",
                                  );

                                  return GestureDetector(
                                    onTap:
                                        () =>
                                            viewModel.toggleSelection(mediaUrl),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          child:
                                              isVideo
                                                  ? GridVideoPlayer(
                                                    url: playableUrl,
                                                    // Tip: only autoplay selected to save CPU/GPU
                                                    autoplay: isSelected,
                                                    loop: true,
                                                    fallbackImageUrl:
                                                        mediaUrl, // Use original URL as fallback
                                                  )
                                                  : Image.network(
                                                    mediaUrl,
                                                    fit: BoxFit.cover,
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                    errorBuilder:
                                                        (
                                                          context,
                                                          error,
                                                          stackTrace,
                                                        ) => const Icon(
                                                          Icons.broken_image,
                                                          color: Colors.grey,
                                                        ),
                                                  ),
                                        ),
                                        if (isSelected)
                                          Positioned(
                                            bottom: 4,
                                            right: 4,
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                color: Colors.pink,
                                                shape: BoxShape.circle,
                                              ),
                                              padding: const EdgeInsets.all(4),
                                              child: const Icon(
                                                Icons.check,
                                                color: Colors.white,
                                                size: 18,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  );
                                }, childCount: viewModel.reactions.length),
                              ),
                            ),
                          ],
                        )
                        : Center(
                          child: Text(
                            "Empty reactions on this page",
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge?.copyWith(
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
              ),
              // Post to Lookbook button is hidden
              // if (hasReactions && viewModel.isStoryOwner)
              //   Positioned(
              //     bottom: 16,
              //     left: 16,
              //     right: 16,
              //     child: ElevatedButton(
              //       style: ElevatedButton.styleFrom(
              //         backgroundColor: Colors.pink,
              //         padding: const EdgeInsets.symmetric(vertical: 14),
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(8),
              //         ),
              //       ),
              //       onPressed:
              //           viewModel.isBusyPosting
              //               ? null
              //               : () => viewModel.postToLookBook(),
              //       child: const Text(
              //         "Post to LookBook",
              //         style: TextStyle(fontSize: 16, color: Colors.white),
              //       ),
              //     ),
              //   ),
              if (viewModel.isBusyPosting)
                Container(
                  color: Colors.black54,
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        );
      },
    );
  }
}

class GridVideoPlayer extends StatefulWidget {
  final String url;
  final bool autoplay; // set false if you want to control when it plays
  final bool loop; // default true
  final String? fallbackImageUrl; // Fallback image if video fails
  const GridVideoPlayer({
    super.key,
    required this.url,
    this.autoplay = true,
    this.loop = true,
    this.fallbackImageUrl,
  });

  @override
  State<GridVideoPlayer> createState() => _GridVideoPlayerState();
}

class _GridVideoPlayerState extends State<GridVideoPlayer>
    with AutomaticKeepAliveClientMixin {
  VideoPlayerController? _vc;
  String? _error;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void didUpdateWidget(GridVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle autoplay changes when widget is updated (e.g., when item is selected/deselected)
    if (oldWidget.autoplay != widget.autoplay &&
        _vc?.value.isInitialized == true) {
      if (widget.autoplay) {
        logger.d(
          "▶️ GridVideoPlayer - Starting playback (autoplay changed to true)",
        );
        _vc?.play();
      } else {
        logger.d(
          "⏸️ GridVideoPlayer - Pausing playback (autoplay changed to false)",
        );
        _vc?.pause();
        // Seek to beginning when paused
        _vc?.seekTo(Duration.zero);
      }
    }
  }

  Future<void> _init() async {
    int maxAttempts = 3;
    int attempt = 0;

    while (attempt < maxAttempts) {
      attempt++;
      try {
        logger.d("🔄 GridVideoPlayer._init - Attempt $attempt/$maxAttempts");
        logger.d("🔄 Original URL: ${widget.url}");

        final src = await _resolvePlayableUri(widget.url.trim());
        logger.d("✅ Resolved URI: ${src.toString()}");
        logger.d("✅ URI scheme: ${src.scheme}");

        // For network URLs, add a delay to allow video to be fully available
        // Reduced delay for faster loading
        if (src.scheme.startsWith('http')) {
          await Future.delayed(Duration(milliseconds: 500 * attempt));
        }

        // Dispose previous controller if exists
        await _vc?.dispose();
        _vc = null;

        logger.d("🔄 Creating VideoPlayerController for: ${src.toString()}");
        _vc =
            src.scheme.startsWith('http')
                ? VideoPlayerController.networkUrl(src)
                : VideoPlayerController.file(File(src.toFilePath()));

        logger.d("🔄 Initializing video player...");
        await _vc!.initialize();
        logger.d("✅ Video player initialized successfully");
        logger.d("✅ Video size: ${_vc!.value.size}");
        logger.d("✅ Video duration: ${_vc!.value.duration}");
        logger.d("✅ Video aspect ratio: ${_vc!.value.aspectRatio}");

        await _vc!.setLooping(widget.loop);
        await _vc!.setVolume(0.0); // muted for grid tiles

        // Seek to first frame to show thumbnail even if not autoplaying
        await _vc!.seekTo(Duration.zero);

        if (widget.autoplay) {
          logger.d("🔄 Autoplay enabled, starting playback...");
          await _vc!.play();
          logger.d("✅ Video playback started");
        } else {
          logger.d("ℹ️ Autoplay disabled, showing first frame");
        }

        if (mounted) setState(() {});
        logger.d("✅ GridVideoPlayer._init - Complete");
        return; // Success - exit retry loop
      } catch (e, stackTrace) {
        logger.e(
          "❌ GridVideoPlayer._init - Attempt $attempt/$maxAttempts failed: $e",
        );
        logger.e("❌ Stack trace: $stackTrace");

        // Dispose failed controller
        try {
          await _vc?.dispose();
          _vc = null;
        } catch (_) {}

        if (attempt < maxAttempts) {
          // Wait before retry with exponential backoff
          final delay = Duration(milliseconds: 2000 * attempt);
          logger.d("⏳ Retrying in ${delay.inMilliseconds}ms...");
          await Future.delayed(delay);
        } else {
          // All attempts failed
          logger.e("❌ All $maxAttempts attempts failed");
          _error = e.toString();
          if (mounted) setState(() {});
        }
      }
    }
  }

  // Vimeo player URL → direct MP4/HLS URL.
  // Cloudinary URLs are already playable, so return as-is
  Future<Uri> _resolvePlayableUri(String input) async {
    if (!input.startsWith('http')) return Uri.file(input);

    // Handle Cloudinary video URLs - they're already playable
    if (input.contains('cloudinary.com')) {
      logger.d("🌩️ Cloudinary video URL detected: $input");

      // Remove any whitespace from the URL (fixes issues with spaces in path)
      String processedUrl = input.trim().replaceAll(RegExp(r'\s+'), '');
      logger.d("🌩️ Cleaned URL (removed spaces): $processedUrl");

      // Convert HTTP to HTTPS (required for video playback on Android)
      if (processedUrl.startsWith('http://')) {
        processedUrl = processedUrl.replaceFirst('http://', 'https://');
        logger.d("🌩️ Converted HTTP to HTTPS: $processedUrl");
      }

      final lowerInput = processedUrl.toLowerCase();

      // Check if it's a video URL
      final isVideoUrl =
          lowerInput.contains('/video/') || lowerInput.contains('video/upload');

      if (isVideoUrl) {
        // If URL already has a video extension (.mp4, .mov, etc.), use it as-is
        if (RegExp(
          r'\.(mp4|mov|webm|avi)(\?|$|/)',
          caseSensitive: false,
        ).hasMatch(lowerInput)) {
          logger.d(
            "🌩️ Cloudinary URL already has video extension, using as-is: $processedUrl",
          );
          return Uri.parse(processedUrl);
        }

        // If no extension and no format parameter, add .mp4 extension
        if (!processedUrl.contains('f_') && !processedUrl.contains('/f_')) {
          final playableUrl =
              processedUrl.endsWith('/')
                  ? '${processedUrl}mp4'
                  : '$processedUrl.mp4';
          logger.d("🌩️ Added .mp4 extension to Cloudinary URL: $playableUrl");
          return Uri.parse(playableUrl);
        }
      }

      logger.d("🌩️ Using Cloudinary URL as-is: $processedUrl");
      return Uri.parse(processedUrl);
    }

    // Handle Vimeo player links like https://player.vimeo.com/video/<id>
    if (input.contains('vimeo.com')) {
      final m = RegExp(r'vimeo\.com/(?:video/)?(\d+)').firstMatch(input);
      final id = m?.group(1);
      if (id == null) throw ArgumentError('Not a Vimeo player URL: $input');

      final res = await http.get(
        Uri.parse('https://player.vimeo.com/video/$id/config'),
      );

      if (res.statusCode != 200) {
        throw StateError('Vimeo config fetch failed: HTTP ${res.statusCode}');
      }

      final j = jsonDecode(res.body) as Map<String, dynamic>;
      // Prefer progressive MP4
      final prog =
          (j['request']?['files']?['progressive'] as List?)?.cast<Map>() ?? [];
      if (prog.isNotEmpty) {
        prog.sort((a, b) => (a['height'] ?? 0).compareTo(b['height'] ?? 0));
        return Uri.parse(prog.last['url'] as String);
      }

      // Fallback to HLS
      final hlsCdns = (j['request']?['files']?['hls']?['cdns'] as Map?) ?? {};
      if (hlsCdns.isNotEmpty) {
        final url = (hlsCdns.values.first as Map)['url'] as String;
        return Uri.parse(url); // .m3u8
      }

      throw StateError('No playable URLs in Vimeo config ($id).');
    }

    // Any other direct URL (mp4 / m3u8)
    return Uri.parse(input);
  }

  @override
  void dispose() {
    _vc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (_error != null) {
      logger.e("❌ GridVideoPlayer build - Error state: $_error");
      logger.e("❌ URL that failed: ${widget.url}");

      // Show fallback image if available
      if (widget.fallbackImageUrl != null &&
          widget.fallbackImageUrl!.isNotEmpty) {
        return Image.network(
          widget.fallbackImageUrl!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder:
              (context, error, stackTrace) => Container(
                color: Colors.black12,
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.broken_image, color: Colors.grey, size: 24),
                      SizedBox(height: 4),
                      Text(
                        'Video Error',
                        style: TextStyle(color: Colors.grey, fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ),
        );
      }

      return Container(
        color: Colors.black12,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.broken_image, color: Colors.grey, size: 24),
              SizedBox(height: 4),
              Text(
                'Video Error',
                style: TextStyle(color: Colors.grey, fontSize: 10),
              ),
            ],
          ),
        ),
      );
    }
    if (_vc?.value.isInitialized != true) {
      logger.d("⏳ GridVideoPlayer - Waiting for initialization...");
      return Container(
        color: Colors.black12,
        child: const Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      );
    }

    // Fill the grid tile
    final size = _vc!.value.size;
    logger.d(
      "🎬 GridVideoPlayer - Rendering video: ${size.width}x${size.height}",
    );
    return FittedBox(
      fit: BoxFit.cover,
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: VideoPlayer(_vc!),
      ),
    );
  }
}
