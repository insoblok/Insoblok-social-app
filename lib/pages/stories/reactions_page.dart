import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:insoblok/services/logger_service.dart';
import 'package:stacked/stacked.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/widgets/widgets.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ReactionsPage extends StatelessWidget {
  final StoryModel story;

  const ReactionsPage({super.key, required this.story});

   bool _isVideo(String url) {
    final u = url.toLowerCase();
    // Be more robust than just "contains('video')"
    return u.contains('vimeo.com') ||
        RegExp(r'\.(mp4|mov|m3u8)(\?|$)', caseSensitive: false).hasMatch(u);
  }


  Future<Uint8List?> _getVideoThumbnail(String videoUrl) async {

    logger.d("_getVideoThumbnail: $videoUrl");
    
    try {
      return await VideoThumbnail.thumbnailData(
        video: videoUrl,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 200,
        quality: 75,
      );
    } catch (e) {
      debugPrint("Error generating thumbnail: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ReactionsProvider>.reactive(
      viewModelBuilder: () => ReactionsProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context, story: story),
      builder: (context, viewModel, _) {
        final hasReactions = viewModel.reactions.isNotEmpty;

        return Scaffold(
          body: Stack(
            children: [
              AppBackgroundView(
                child: hasReactions
                    ? CustomScrollView(
                        controller: viewModel.controller,
                        physics: const BouncingScrollPhysics(),
                        slivers: [
                          SliverAppBar(
                            pinned: true,
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            leading: IconButton(
                              icon: const Icon(Icons.arrow_back, color: Colors.white),
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
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final mediaUrl = viewModel.reactions[index];
                                  final isVideo = _isVideo(mediaUrl);
                                  final isSelected =
                                      viewModel.isSelected(mediaUrl);

                                  return GestureDetector(
                                    onTap: () =>
                                        viewModel.toggleSelection(mediaUrl),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: isVideo
                                              ? GridVideoPlayer(
                                                  url: mediaUrl,
                                                  // Tip: only autoplay selected to save CPU/GPU
                                                  autoplay: isSelected,
                                                  loop: true,
                                                )
                                              : Image.network(
                                                  mediaUrl,
                                                  fit: BoxFit.cover,
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                  errorBuilder: (context, error,
                                                          stackTrace) =>
                                                      const Icon(Icons.broken_image,
                                                          color: Colors.grey),
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
                                },
                                childCount: viewModel.reactions.length,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Center(
                        child: Text(
                          "Empty reactions on this page",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
              ),
              if (hasReactions && viewModel.isStoryOwner)
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: viewModel.isBusyPosting
                        ? null
                        : () => viewModel.postToLookBook(),
                    child: const Text(
                      "Post to LookBook",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              if (viewModel.isBusyPosting)
                Container(
                  color: Colors.black54,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}


// lib/widgets/grid_video_player.dart

class GridVideoPlayer extends StatefulWidget {
  final String url;
  final bool autoplay;   // set false if you want to control when it plays
  final bool loop;       // default true
  const GridVideoPlayer({
    super.key,
    required this.url,
    this.autoplay = true,
    this.loop = true,
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

  Future<void> _init() async {
    try {
      final src = await _resolvePlayableUri(widget.url.trim());

      _vc = src.scheme.startsWith('http')
          ? VideoPlayerController.networkUrl(src)
          : VideoPlayerController.file(File(src.toFilePath()));

      await _vc!.initialize();
      await _vc!.setLooping(widget.loop);
      await _vc!.setVolume(0.0); // muted for grid tiles

      if (widget.autoplay) {
        await _vc!.play();
      }

      if (mounted) setState(() {});
    } catch (e) {
      _error = e.toString();
      if (mounted) setState(() {});
    }
  }

  // Vimeo player URL → direct MP4/HLS URL.
  Future<Uri> _resolvePlayableUri(String input) async {
    if (!input.startsWith('http')) return Uri.file(input);

    // Handle Vimeo player links like https://player.vimeo.com/video/<id>
    if (input.contains('vimeo.com')) {
      final m = RegExp(r'vimeo\.com/(?:video/)?(\d+)').firstMatch(input);
      final id = m?.group(1);
      if (id == null) throw ArgumentError('Not a Vimeo player URL: $input');
      
      logger.d("vimeo id $id");

      final res =
          await http.get(Uri.parse('https://player.vimeo.com/video/$id/config'));

      logger.d("vimeo res ${res.statusCode}");
      if (res.statusCode != 200) {
        throw StateError('Vimeo config fetch failed: HTTP ${res.statusCode}');
      }

      logger.d("vimeo body ${res.body}");
      final j = jsonDecode(res.body) as Map<String, dynamic>;
      // final j = jsonDecode(res.body) as Map<String, dynamic>;
      logger.d("vimeo body ${res.body}");
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
      return const Icon(Icons.broken_image, color: Colors.grey);
    }
    if (_vc?.value.isInitialized != true) {
      return const Center(child: CircularProgressIndicator());
    }

    // Fill the grid tile
    final size = _vc!.value.size;
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

