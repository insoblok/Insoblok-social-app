import 'package:flutter/material.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

class StoryCarouselView extends StatefulWidget {
  final StoryModel story;
  final double? height;
  final bool showPlaceholder;
  final bool autoPlay;
  final ScrollPhysics? scrollPhysics;
  final BoxFit? boxFit;
  final void Function(int index)? onChangePage;

  const StoryCarouselView({
    super.key,
    required this.story,
    this.height = 240.0,
    this.showPlaceholder = false,
    this.autoPlay = false,
    this.scrollPhysics,
    this.boxFit,
    this.onChangePage,
  });

  @override
  State<StoryCarouselView> createState() => _StoryCarouselViewState();
}

class _StoryCarouselViewState extends State<StoryCarouselView> {
  var indexListener = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    var medias = widget.story.medias ?? [];
    if (medias.isEmpty) {
      if (widget.showPlaceholder) {
        return AspectRatio(
          aspectRatio: 3 / 2,
          child: AIImage(
            AIImages.placehold,
            height: widget.height,
            fit: widget.boxFit ?? BoxFit.fitHeight,
            width: double.infinity,
          ),
        );
      } else {
        return Container();
      }
    } else if (medias.length == 1) {
      var media = medias.first;
      return Container(
        width: double.infinity,
        height: widget.height,
        decoration: BoxDecoration(
          color: AIColors.grey,
          borderRadius: BorderRadius.circular(6),
        ),
        child: MediaCarouselCell(
          media: media,
          height: widget.height,
          boxFit: widget.boxFit,
        ),
      );
    }
    return ValueListenableBuilder(
      valueListenable: indexListener,
      builder: (context, value, _) {
        return SizedBox(
          height: widget.height,
          child: Stack(
            children: [
              CarouselSlider.builder(
                itemCount: widget.story.medias!.length,
                options: CarouselOptions(
                  viewportFraction: 1.0,
                  enlargeCenterPage: false,
                  enableInfiniteScroll: false,
                  autoPlay: widget.autoPlay,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(seconds: 1),
                  aspectRatio: 3 / 2,
                  height: widget.height,
                  scrollPhysics:
                      widget.scrollPhysics ?? AlwaysScrollableScrollPhysics(),
                  onPageChanged: (index, reason) {
                    indexListener.value = index;
                    if (widget.onChangePage != null) {
                      widget.onChangePage!(index);
                    }
                  },
                ),
                itemBuilder: (context, index, realIdx) {
                  var media = medias[index];
                  return Container(
                    width: double.infinity,
                    height: widget.height,
                    decoration: BoxDecoration(
                      color: AIColors.grey,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: MediaCarouselCell(
                      media: media,
                      boxFit: widget.boxFit,
                      height: widget.height,
                    ),
                  );
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: PageableIndicator(
                  pageLength: medias.length,
                  index: value,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class MediaCarouselCell extends StatefulWidget {
  final MediaStoryModel media;
  final double? height;
  final BoxFit? boxFit;

  const MediaCarouselCell({
    super.key,
    required this.media,
    this.height = 240.0,
    this.boxFit,
  });

  @override
  State<MediaCarouselCell> createState() => _MediaCarouselCellState();
}

class _MediaCarouselCellState extends State<MediaCarouselCell> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();

    if (widget.media.type == 'video') {
      _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(widget.media.link!),
      );

      _videoPlayerController.addListener(() {
        if (_videoPlayerController.value.isCompleted) {
          setState(() {
            isPlaying = false;
            _videoPlayerController.seekTo(Duration(milliseconds: 0));
          });
        }
      });

      _videoPlayerController.initialize().then((value) {
        _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController,
          autoPlay: true,
          looping: false,
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
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3 / 2,
      child:
          widget.media.type == 'image'
              ? AIImage(
                widget.media.link,
                width: double.infinity,
                height: widget.height,
                fit: widget.boxFit ?? BoxFit.fitHeight,
              )
              : _videoPlayerController.value.isInitialized
              ? LayoutBuilder(
                builder: (context, constraints) {
                  return SizedBox(
                    height: constraints.maxHeight,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: AspectRatio(
                            aspectRatio:
                                _videoPlayerController.value.aspectRatio,
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: SizedBox(
                                width: _videoPlayerController.value.size.width,
                                height:
                                    _videoPlayerController.value.size.height,
                                child: Chewie(controller: _chewieController),
                              ),
                            ),
                          ),
                        ),
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
                              isPlaying
                                  ? Icons.pause_circle
                                  : Icons.play_circle,
                              color: Colors.white,
                              size: 32.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
              : AIImage(
                AIImages.imgBackSplash,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
    );
  }

  @override
  void dispose() {
    if (widget.media.type == 'video') {
      _videoPlayerController.dispose();
      _chewieController.dispose();
    }
    super.dispose();
  }
}
