import 'dart:ui';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:video_player/video_player.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/widgets/widgets.dart';

class ReactionVideoDetailPage extends StatelessWidget {
  final String storyID;
  final String url;
  final String videoPath;

  const ReactionVideoDetailPage({
    super.key,
    required this.storyID,
    required this.url,
    required this.videoPath,
  });

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ReactionVideoDetailProvider>.reactive(
      viewModelBuilder: () => ReactionVideoDetailProvider(),
      onViewModelReady: (viewModel) =>
          viewModel.init(context, storyID: storyID, url: url, videoPath: videoPath),
      builder: (context, viewModel, _) {
        return Scaffold(
          body: Stack(
            children: [
              AIImage(url, width: double.infinity, height: double.infinity),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
                child: viewModel.face != null || viewModel.videoPath != null
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 24.0,
                          children: [
                            // Top icon annotations
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 8.0,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                spacing: 24.0,
                                children: [
                                  for (var content in viewModel.annotations) ...{
                                    Column(
                                      spacing: 4.0,
                                      children: [
                                        AIImage(
                                          content.icon,
                                          width: 60.0,
                                          height: 60.0,
                                        ),
                                        Text(
                                          '${content.title}\n${content.desc}',
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context).textTheme.bodyMedium,
                                        ),
                                      ],
                                    ),
                                  },
                                ],
                              ),
                            ),

                            // Replace face image with circular video
                            if (File(viewModel.videoPath).existsSync())
                              _CircularVideoPlayer(videoPath: viewModel.videoPath)
                            else
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Theme.of(context).colorScheme.secondary,
                                    width: 0.5,
                                  ),
                                  borderRadius: BorderRadius.circular(24.0),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(24.0),
                                  child: AIImage(
                                    viewModel.face,
                                    fit: BoxFit.contain,
                                    width: MediaQuery.of(context).size.width * 0.7,
                                  ),
                                ),
                              ),

                            const SizedBox(height: 40.0),

                            // Reaction buttons row
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24.0,
                                vertical: 8.0,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSecondary
                                    .withAlpha(32),
                                border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                ),
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                spacing: 40.0,
                                children: [
                                  for (var data in kReactionPostIconData) ...{
                                    InkWell(
                                      onTap: () => viewModel.onClickActionButton(
                                        kReactionPostIconData.indexOf(data),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          AIImage(
                                            data['icon'],
                                            height: 24.0,
                                            color: Theme.of(context).primaryColor,
                                          ),
                                          Text(
                                            data['title'] as String,
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall,
                                          ),
                                        ],
                                      ),
                                    ),
                                  },
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(),
              ),
              CustomCircleBackButton(),
              if (viewModel.isBusy)
                Align(
                  alignment: Alignment.center,
                  child: Center(child: Loader(size: 60.0)),
                ),
            ],
          ),
        );
      },
    );
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
    _controller = VideoPlayerController.file(File(widget.videoPath))
      ..initialize().then((_) {
        setState(() {
          _initialized = true;
          _controller.setLooping(true);
          _controller.play();
        });
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
    return ClipOval(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.secondary,
            width: 2,
          ),
        ),
        child: _initialized
            ? VideoPlayer(_controller)
            : const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
    );
  }
}
