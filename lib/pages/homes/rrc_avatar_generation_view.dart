import 'dart:ui';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

final MAIN_IMAGE_HEIGHT_FACTOR = 0.75;
final AVATAR_IMAGE_HEIGHT_FACTOR = 0.08;

class RRCAvatarGenerationView extends StatefulWidget {
  final String url;
  final File face;
  final String storyID;
  final String origin;
  const RRCAvatarGenerationView({
    super.key,
    required this.face,
    required this.url,
    required this.origin,
    required this.storyID,
  });

  @override
  State<RRCAvatarGenerationView> createState() =>
      _RRCAvatarGenerationViewState();
}

class _RRCAvatarGenerationViewState extends State<RRCAvatarGenerationView> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RRCAvatarGenerationProvider>.reactive(
      viewModelBuilder: () => RRCAvatarGenerationProvider(),
      onViewModelReady:
          (viewModel) =>
              viewModel.init(widget.url, widget.face, widget.storyID, context),
      builder:
          (context, viewModel, child) => Scaffold(
            appBar: AppBar(
              title: Text(
                widget.origin == "profile"
                    ? 'AI Avatar Generation'
                    : 'AI Reaction Generation',
              ),
              centerTitle: true,
              actions: [
                // Only show save button when called from account_avatar_provider (origin == "profile")
                // Hide it when called from story_widget (origin == "dashboard")
                if (widget.origin.isNotEmpty && widget.origin == "profile")
                  IconButton(
                    onPressed: () async {
                      await viewModel.handleTapSave(context);
                    },
                    icon: const Icon(Icons.save),
                  ),
              ],
            ),
            body:
                viewModel.isBusy
                    ? Center(child: CircularProgressIndicator())
                    : Container(
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height - 100,
                                width: MediaQuery.of(context).size.width,
                              ),
                              if (viewModel.state ==
                                  AvatarProcessingMode.avatarGeneration) ...{
                                viewModel
                                        .avatarResults[viewModel.tappedImage]
                                        .isNotEmpty
                                    ? Center(
                                      child: Image.memory(
                                        viewModel.avatarResults[viewModel
                                            .tappedImage],
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height *
                                            MAIN_IMAGE_HEIGHT_FACTOR,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                    : AIImage(
                                      widget
                                          .face, // supports File or String in your project
                                      fit: BoxFit.cover,
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height *
                                          MAIN_IMAGE_HEIGHT_FACTOR,
                                    ),
                              } else ...{
                                // Video generation mode: Always show origin face before generation
                                // Only show generated video after it's been created
                                if (viewModel
                                    .videoResults[viewModel.tappedImage]
                                    .isNotEmpty)
                                  VideoPlayerWidget(
                                    key: ValueKey(
                                      viewModel.videoResults[viewModel
                                          .tappedImage],
                                    ),
                                    path:
                                        viewModel.videoResults[viewModel
                                            .tappedImage],
                                    width: MediaQuery.of(context).size.width,
                                    height:
                                        MediaQuery.of(context).size.height *
                                        MAIN_IMAGE_HEIGHT_FACTOR,
                                    border: Colors.transparent,
                                  )
                                else
                                  // Always show origin face for video templates (not generated avatar)
                                  AIImage(
                                    widget.face,
                                    fit: BoxFit.cover,
                                    width: MediaQuery.of(context).size.width,
                                    height:
                                        MediaQuery.of(context).size.height *
                                        MAIN_IMAGE_HEIGHT_FACTOR,
                                  ),
                              },
                              if (viewModel.isSelected) ...{
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height *
                                      MAIN_IMAGE_HEIGHT_FACTOR,
                                  width: MediaQuery.of(context).size.width,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          viewModel.isProcessing
                                              ? (viewModel.state ==
                                                      AvatarProcessingMode
                                                          .avatarGeneration
                                                  ? "Applying selected avatar"
                                                  : "Generating video avatar")
                                              : "",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 36,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 16.0),
                                        if (viewModel.isProcessing)
                                          Center(
                                            child:
                                                LoadingAnimationWidget.threeArchedCircle(
                                                  color: Colors.white,
                                                  size:
                                                      MediaQuery.of(
                                                        context,
                                                      ).size.width *
                                                      0.2,
                                                ),
                                          ),
                                        SizedBox(height: 16.0),
                                        if (viewModel.isSelected &&
                                            viewModel.isCounting)
                                          Center(
                                            child: AnimatedFlipCounter(
                                              value:
                                                  viewModel.TIMER_LENGTH -
                                                  viewModel.count,
                                              // textAlign: TextAlign.center,
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(fontSize: 36),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              },
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.all(6.0),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height *
                                            0.1,
                                        child: ListView.separated(
                                          scrollDirection: Axis.horizontal,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8,
                                          ),
                                          controller: _pageController,
                                          itemCount:
                                              1 + // Check icon circle (first position)
                                              (viewModel
                                                      .avatarTemplates
                                                      .length -
                                                  1) + // Rest of image templates (skip index 0 which is check icon)
                                              (widget.origin == "profile"
                                                  ? 0
                                                  : (viewModel
                                                          .avatarVideos
                                                          .length -
                                                      1)), // Video templates (skip first empty one, actualIndex 0) - hidden when origin is "profile"
                                          separatorBuilder:
                                              (_, __) =>
                                                  const SizedBox(width: 2),
                                          itemBuilder: (context, index) {
                                            // First item (index 0) is always the check icon circle
                                            if (index == 0) {
                                              return GestureDetector(
                                                onTap: () {
                                                  if (viewModel.state !=
                                                      AvatarProcessingMode
                                                          .avatarGeneration) {
                                                    viewModel.state =
                                                        AvatarProcessingMode
                                                            .avatarGeneration;
                                                  }
                                                  viewModel.handleTapImage(
                                                    0,
                                                    context,
                                                  );
                                                },
                                                child: Container(
                                                  width:
                                                      MediaQuery.of(
                                                        context,
                                                      ).size.height *
                                                      AVATAR_IMAGE_HEIGHT_FACTOR,
                                                  height:
                                                      MediaQuery.of(
                                                        context,
                                                      ).size.height *
                                                      AVATAR_IMAGE_HEIGHT_FACTOR,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      AnimatedContainer(
                                                        duration:
                                                            const Duration(
                                                              milliseconds: 300,
                                                            ),
                                                        padding:
                                                            const EdgeInsets.all(
                                                              4,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          border: Border.all(
                                                            color:
                                                                viewModel.tappedImage ==
                                                                            0 &&
                                                                        viewModel.state ==
                                                                            AvatarProcessingMode.avatarGeneration
                                                                    ? (viewModel
                                                                            .isSelected
                                                                        ? Colors
                                                                            .green
                                                                        : Colors
                                                                            .red)
                                                                    : Colors
                                                                        .transparent,
                                                            width: 2,
                                                          ),
                                                        ),
                                                        curve:
                                                            Curves
                                                                .easeInOutCubic,
                                                        child: Container(
                                                          width:
                                                              MediaQuery.of(
                                                                context,
                                                              ).size.height *
                                                              AVATAR_IMAGE_HEIGHT_FACTOR,
                                                          height:
                                                              MediaQuery.of(
                                                                context,
                                                              ).size.height *
                                                              AVATAR_IMAGE_HEIGHT_FACTOR,
                                                          padding:
                                                              const EdgeInsets.all(
                                                                20,
                                                              ),
                                                          decoration:
                                                              BoxDecoration(
                                                                shape:
                                                                    BoxShape
                                                                        .circle,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                          child: CircleAvatar(
                                                            foregroundImage:
                                                                AssetImage(
                                                                  AIImages
                                                                      .icCheck2,
                                                                ),
                                                            backgroundColor:
                                                                Colors.grey,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }

                                            // Adjust index after removing the first item
                                            final adjustedIndex = index - 1;
                                            final imageTemplatesCount =
                                                viewModel
                                                    .avatarTemplates
                                                    .length -
                                                1; // Exclude first (check icon)

                                            final isImageTemplate =
                                                adjustedIndex <
                                                imageTemplatesCount;

                                            // For image templates, actualIndex starts from 1 (skip 0 which is check icon)
                                            // For video templates, actualIndex starts from 1 (skip 0 which is empty)
                                            final actualIndex =
                                                isImageTemplate
                                                    ? adjustedIndex + 1
                                                    : (adjustedIndex -
                                                            imageTemplatesCount) +
                                                        1;

                                            final isVideoTemplate =
                                                !isImageTemplate &&
                                                widget.origin != "profile" &&
                                                adjustedIndex >=
                                                    imageTemplatesCount;

                                            return GestureDetector(
                                              onTap: () {
                                                if (isVideoTemplate &&
                                                    actualIndex == 0)
                                                  return;
                                                // Update state based on template type
                                                if (isVideoTemplate &&
                                                    viewModel.state !=
                                                        AvatarProcessingMode
                                                            .videoGeneration) {
                                                  viewModel.state =
                                                      AvatarProcessingMode
                                                          .videoGeneration;
                                                } else if (!isVideoTemplate &&
                                                    viewModel.state !=
                                                        AvatarProcessingMode
                                                            .avatarGeneration) {
                                                  viewModel.state =
                                                      AvatarProcessingMode
                                                          .avatarGeneration;
                                                }
                                                viewModel.handleTapImage(
                                                  actualIndex,
                                                  context,
                                                );
                                              },
                                              child: Container(
                                                width:
                                                    MediaQuery.of(
                                                      context,
                                                    ).size.height *
                                                    AVATAR_IMAGE_HEIGHT_FACTOR,
                                                height:
                                                    MediaQuery.of(
                                                      context,
                                                    ).size.height *
                                                    AVATAR_IMAGE_HEIGHT_FACTOR,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    AnimatedContainer(
                                                      duration: const Duration(
                                                        milliseconds: 300,
                                                      ),
                                                      padding:
                                                          !isVideoTemplate
                                                              ? const EdgeInsets.all(
                                                                4,
                                                              )
                                                              : EdgeInsets.zero,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                          color:
                                                              viewModel.tappedImage ==
                                                                          actualIndex &&
                                                                      viewModel
                                                                              .state ==
                                                                          (isVideoTemplate
                                                                              ? AvatarProcessingMode.videoGeneration
                                                                              : AvatarProcessingMode.avatarGeneration)
                                                                  ? (viewModel
                                                                          .isSelected
                                                                      ? Colors
                                                                          .green
                                                                      : Colors
                                                                          .red)
                                                                  : Colors
                                                                      .transparent,
                                                          width: 2,
                                                        ),
                                                      ),
                                                      curve:
                                                          Curves.easeInOutCubic,
                                                      child:
                                                          isVideoTemplate
                                                              ? FutureBuilder<
                                                                bool
                                                              >(
                                                                future: () async {
                                                                  await Future.delayed(
                                                                    Duration(
                                                                      microseconds:
                                                                          2000,
                                                                    ),
                                                                  );
                                                                  return true;
                                                                }(),
                                                                builder: (
                                                                  context,
                                                                  snapshot,
                                                                ) {
                                                                  if (snapshot
                                                                          .hasData &&
                                                                      snapshot.data ==
                                                                          true) {
                                                                    return _CachedVideoWidget(
                                                                      path:
                                                                          viewModel
                                                                              .avatarVideos[actualIndex],
                                                                      isSelected:
                                                                          viewModel
                                                                              .tappedImage ==
                                                                          actualIndex,
                                                                      radius:
                                                                          MediaQuery.of(
                                                                                context,
                                                                              ).size.height *
                                                                              AVATAR_IMAGE_HEIGHT_FACTOR -
                                                                          2,
                                                                      onValidation:
                                                                          viewModel
                                                                              .validateFile,
                                                                    );
                                                                  } else {
                                                                    return Container(
                                                                      width:
                                                                          MediaQuery.of(
                                                                                context,
                                                                              ).size.height *
                                                                              AVATAR_IMAGE_HEIGHT_FACTOR -
                                                                          2,
                                                                      height:
                                                                          MediaQuery.of(
                                                                                context,
                                                                              ).size.height *
                                                                              AVATAR_IMAGE_HEIGHT_FACTOR -
                                                                          2,
                                                                      decoration: BoxDecoration(
                                                                        shape:
                                                                            BoxShape.circle,
                                                                        color:
                                                                            Colors.grey[300],
                                                                        border: Border.all(
                                                                          color:
                                                                              viewModel.tappedImage ==
                                                                                      actualIndex
                                                                                  ? Colors.red
                                                                                  : Colors.transparent,
                                                                          width:
                                                                              2,
                                                                        ),
                                                                      ),
                                                                      child: Icon(
                                                                        Icons
                                                                            .video_library_outlined,
                                                                        color:
                                                                            Colors.grey[600],
                                                                      ),
                                                                    );
                                                                  }
                                                                },
                                                              )
                                                              // Image templates section (after video templates)
                                                              // Note: actualIndex starts from 1 (index 0 is already shown as first item)
                                                              : CircleAvatar(
                                                                radius:
                                                                    MediaQuery.of(
                                                                      context,
                                                                    ).size.height *
                                                                    AVATAR_IMAGE_HEIGHT_FACTOR /
                                                                    2,
                                                                backgroundImage:
                                                                    AssetImage(
                                                                      viewModel
                                                                          .avatarTemplates[actualIndex],
                                                                    ),
                                                              ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),

                                      if (widget.origin.isNotEmpty &&
                                          widget.origin != "profile")
                                        SafeArea(
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 16.0,
                                                    ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    GestureDetector(
                                                      onTap:
                                                          viewModel.togglePost,
                                                      child: Row(
                                                        children: [
                                                          FittedBox(
                                                            child: Text("POST"),
                                                          ),
                                                          SizedBox(width: 4.0),
                                                          Icon(
                                                            viewModel.isPosting
                                                                ? Icons
                                                                    .arrow_drop_up
                                                                : Icons
                                                                    .arrow_drop_down,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 4.0),
                                              if (viewModel.isPosting)
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Container(
                                                      width:
                                                          MediaQuery.of(
                                                            context,
                                                          ).size.width *
                                                          0.2,
                                                      height: 54,
                                                      child: OutlinedButton(
                                                        onPressed:
                                                            viewModel
                                                                .postAsReaction,
                                                        style: OutlinedButton.styleFrom(
                                                          padding:
                                                              EdgeInsets.all(2),
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  8.0,
                                                                ),
                                                          ),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                vertical: 2.0,
                                                              ),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              AIImage(
                                                                AIImages
                                                                    .icShare2,
                                                                color:
                                                                    Colors
                                                                        .white,
                                                                width: 24.0,
                                                                height: 24.0,
                                                              ),
                                                              Text(
                                                                "Post as RRC",
                                                                style:
                                                                    Theme.of(
                                                                          context,
                                                                        )
                                                                        .textTheme
                                                                        .bodySmall,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(
                                                            context,
                                                          ).size.width *
                                                          0.2,
                                                      height: 54,
                                                      child: OutlinedButton(
                                                        onPressed:
                                                            viewModel
                                                                .saveToGallery,
                                                        style: OutlinedButton.styleFrom(
                                                          padding:
                                                              EdgeInsets.all(2),
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  8.0,
                                                                ),
                                                          ),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets.all(
                                                                2.0,
                                                              ),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              AIImage(
                                                                AIImages
                                                                    .icBookMark,
                                                                color:
                                                                    Colors
                                                                        .white,
                                                                width: 24.0,
                                                                height: 24.0,
                                                              ),
                                                              FittedBox(
                                                                child: Text(
                                                                  "Save to Gallery",
                                                                  style:
                                                                      Theme.of(
                                                                        context,
                                                                      ).textTheme.bodySmall,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(
                                                            context,
                                                          ).size.width *
                                                          0.2,
                                                      height: 54,
                                                      child: OutlinedButton(
                                                        onPressed: () {
                                                          Navigator.of(
                                                            context,
                                                          ).pop();
                                                        },
                                                        style: OutlinedButton.styleFrom(
                                                          padding:
                                                              EdgeInsets.all(2),
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  8.0,
                                                                ),
                                                          ),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets.all(
                                                                2.0,
                                                              ),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              AIImage(
                                                                AIImages
                                                                    .icCancel,
                                                                color:
                                                                    Colors
                                                                        .white,
                                                                width: 24.0,
                                                                height: 24.0,
                                                              ),
                                                              FittedBox(
                                                                child: Text(
                                                                  "Cancel",
                                                                  style:
                                                                      Theme.of(
                                                                        context,
                                                                      ).textTheme.bodySmall,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
          ),
    );
  }
}

class _CachedVideoWidget extends StatefulWidget {
  final String path;
  final bool isSelected;
  final double radius;
  final Future<bool> Function(String) onValidation;

  const _CachedVideoWidget({
    required this.path,
    required this.isSelected,
    required this.radius,
    required this.onValidation,
  });

  @override
  State<_CachedVideoWidget> createState() => _CachedVideoWidgetState();
}

class _CachedVideoWidgetState extends State<_CachedVideoWidget> {
  bool? _isValid;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _validateVideo();
  }

  @override
  void didUpdateWidget(_CachedVideoWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.path != widget.path) {
      _validateVideo();
    }
  }

  Future<void> _validateVideo() async {
    if (widget.path.isEmpty) {
      setState(() {
        _isValid = false;
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final isValid = await widget.onValidation(widget.path);
      if (mounted) {
        setState(() {
          _isValid = isValid;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isValid = false;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        width: widget.radius,
        height: widget.radius,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[300],
        ),
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    if (_isValid == true) {
      return VideoPlayerWidget(
        path: widget.path,
        circular: true,
        radius: widget.radius,
        border: Colors.transparent,
      );
    } else {
      // Show placeholder for invalid video
      return Container(
        width: widget.radius,
        height: widget.radius,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[300],
          border: Border.all(
            color: widget.isSelected ? Colors.red : Colors.transparent,
            width: 2,
          ),
        ),
        child: Icon(Icons.video_library_outlined, color: Colors.grey[600]),
      );
    }
  }
}

class _CachedMainVideoWidget extends StatefulWidget {
  final String path;
  final Uint8List fallbackAvatar;
  final File fallbackFace;
  final double width;
  final double height;
  final Future<bool> Function(String) onValidation;

  const _CachedMainVideoWidget({
    required this.path,
    required this.fallbackAvatar,
    required this.fallbackFace,
    required this.width,
    required this.height,
    required this.onValidation,
  });

  @override
  State<_CachedMainVideoWidget> createState() => _CachedMainVideoWidgetState();
}

class _CachedMainVideoWidgetState extends State<_CachedMainVideoWidget> {
  bool? _isValid;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _validateVideo();
  }

  @override
  void didUpdateWidget(_CachedMainVideoWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.path != widget.path) {
      _validateVideo();
    }
  }

  Future<void> _validateVideo() async {
    if (widget.path.isEmpty) {
      setState(() {
        _isValid = false;
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final isValid = await widget.onValidation(widget.path);
      if (mounted) {
        setState(() {
          _isValid = isValid;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isValid = false;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_isValid == true) {
      return VideoPlayerWidget(
        path: widget.path,
        width: widget.width,
        height: widget.height,
        border: Colors.transparent,
      );
    } else {
      // Fallback to avatar image if video is invalid
      return widget.fallbackAvatar.isNotEmpty
          ? Center(
            child: Image.memory(
              widget.fallbackAvatar,
              width: widget.width,
              height: widget.height,
              fit: BoxFit.cover,
            ),
          )
          : AIImage(
            widget.fallbackFace,
            fit: BoxFit.cover,
            width: widget.width,
            height: widget.height,
          );
    }
  }
}
