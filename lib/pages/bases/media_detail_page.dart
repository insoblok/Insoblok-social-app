import 'dart:ui';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:video_player/video_player.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

class MediaDetailPage extends StatelessWidget {
  final MediaDetailModel model;
  const MediaDetailPage({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MediaDetailProvider>.reactive(
      viewModelBuilder: () => MediaDetailProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context, model: model),
      builder: (context, viewModel, _) {
        return Scaffold(
          body: Stack(
            children: [
              AIImage(
                viewModel.medias[viewModel.index],
                width: double.infinity,
                height: double.infinity,
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
                child:
                    viewModel.imgRemix.isEmpty
                        ? PageView(
                          scrollDirection: Axis.horizontal,
                          controller: viewModel.controller,
                          onPageChanged: (int num) => viewModel.index = num,
                          children: [
                            for (var media in viewModel.medias) ...{
                              Center(
                                child: Container(
                                  margin: EdgeInsets.all(40.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.secondary,
                                      width: 0.5,
                                    ),
                                    borderRadius: BorderRadius.circular(24.0),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(24.0),
                                    child: _buildMediaWidget(media),
                                  ),
                                ),
                              ),
                            },
                          ],
                        )
                        : MediaRemixWidget(),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 16.0,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSecondary.withAlpha(32),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Text(
                    '${viewModel.index + 1} / ${viewModel.medias.length}',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ),
              ),
              CustomCircleBackButton(),
              // Align(
              //   alignment: Alignment.topRight,
              //   child: Padding(
              //     padding: EdgeInsets.only(
              //       right: 20.0,
              //       top: MediaQuery.of(context).padding.top + 12.0,
              //     ),
              //     child: CircleImageButton(
              //       src: Icons.share,
              //       size: 36.0,
              //       onTap:
              //           () => AIHelpers.shareFileToSocial(
              //             viewModel.medias[viewModel.index],
              //           ),
              //     ),
              //   ),
              // ),
              Align(
                alignment: Alignment.bottomCenter,
                child: RemixActionView(),
              ),
              if (viewModel.isRemixing ||
                  viewModel.isPostingLookbook ||
                  viewModel.isFeedDeleting)
                Align(
                  alignment: Alignment.center,
                  child: Center(child: Loader(size: 40.0)),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMediaWidget(String mediaUrl) {
    final lowerUrl = mediaUrl.toLowerCase();
    if (lowerUrl.contains('.mp4') || lowerUrl.contains('.mov')) {
      // Video file: show video player
      return _CircularVideoPlayer(videoPath: mediaUrl);
    } else {
      // Image file: show AIImage as before
      return AIImage(mediaUrl, fit: BoxFit.contain);
    }
  }
}

class _CircularVideoPlayer extends StatefulWidget {
  final String videoPath;

  const _CircularVideoPlayer({required this.videoPath});

  @override
  State<_CircularVideoPlayer> createState() => _CircularVideoPlayerState();
}

class _CircularVideoPlayerState extends State<_CircularVideoPlayer> {
  late VideoPlayerController _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    if (widget.videoPath.startsWith('http') ||
        widget.videoPath.startsWith('https')) {
      _controller = VideoPlayerController.network(widget.videoPath);
    } else {
      _controller = VideoPlayerController.file(File(widget.videoPath));
    }

    _controller
        .initialize()
        .then((_) {
          setState(() {
            _initialized = true;
            _controller.setLooping(true);
            _controller.play();
          });
        })
        .catchError((error) {
          // Handle errors if needed, e.g. show error UI
          print("Video initialization error: $error");
        });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double size = MediaQuery.of(context).size.width * 0.7;
    return ClipRRect(
      borderRadius: BorderRadius.circular(24.0),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.secondary,
            width: 2,
          ),
        ),
        child:
            _initialized
                ? VideoPlayer(_controller)
                : const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
      ),
    );
  }
}
