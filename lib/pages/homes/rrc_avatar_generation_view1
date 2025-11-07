import 'dart:ui';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';
import 'package:insoblok/pages/pages.dart';

final MAIN_IMAGE_HEIGHT_FACTOR = 0.65;

class RRCAvatarGenerationView extends StatefulWidget {
  final String url;
  final File face;
  const RRCAvatarGenerationView({super.key, required this.face, required this.url});

  @override
  State<RRCAvatarGenerationView> createState() => _RRCAvatarGenerationViewState();
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
      onViewModelReady: (viewModel) => viewModel.init(widget.url, widget.face, context),
      builder: (context, viewModel, child) => Scaffold(
        appBar: AppBar(
          title: const Text('Avatar Generation'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.save),
            ),
          ],
        ),
        body: viewModel.isBusy ?
          Center(
            child: CircularProgressIndicator(),
          )
        : Container(
          decoration: BoxDecoration(
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                children: [
                  if (viewModel.state == AvatarProcessingMode.avatarGeneration) ... {
                    viewModel.avatarResults[viewModel.tappedImage].isNotEmpty ?
                    Center(
                      child: Image.memory(
                        viewModel.avatarResults[viewModel.tappedImage],
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * MAIN_IMAGE_HEIGHT_FACTOR, 
                        fit: BoxFit.cover
                      ),
                    ) :
                    AIImage(
                      widget.face, // supports File or String in your project
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * MAIN_IMAGE_HEIGHT_FACTOR,
                    ),
                  }
                  else ... {
                    if(viewModel.videoResults[viewModel.tappedImage].isNotEmpty)
                      VideoPlayerWidget(
                        path: viewModel.videoResults[viewModel.tappedImage],
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * MAIN_IMAGE_HEIGHT_FACTOR,
                        border: Colors.transparent,
                      )
                    else
                      // Fallback to avatar image if video is invalid
                      if (viewModel.avatarResults[viewModel.selectedAvatar].isNotEmpty)
                        Center(
                          child: Image.memory(
                            viewModel.avatarResults[viewModel.selectedAvatar],
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * MAIN_IMAGE_HEIGHT_FACTOR, 
                            fit: BoxFit.cover
                          ),
                        )
                      else
                        AIImage(
                          widget.face,
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * MAIN_IMAGE_HEIGHT_FACTOR,
                        )
                    },
                  if (viewModel.isSelected)
                    SizedBox(
                      height: MediaQuery.of(context).size.height * MAIN_IMAGE_HEIGHT_FACTOR,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                viewModel.isProcessing ? "Applying selected avatar" : "",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 16.0),
                              if (viewModel.isSelected && viewModel.isCounting)
                              Center(
                                child: AnimatedFlipCounter(
                                  value: viewModel.TIMER_LENGTH - viewModel.count, 
                                  // textAlign: TextAlign.center,
                                  textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontSize: 36,
                                  )
                                ),
                              ),
                            ],
                          ),
                      ),
                    )
                ],
              ),
              viewModel.state == AvatarProcessingMode.avatarGeneration ? Expanded(
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  controller: _pageController,
                  itemCount: viewModel.avatarTemplates.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        viewModel.handleTapImage(index, context);
                      },
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: viewModel.tappedImage == index? (viewModel.isSelected ? Colors.green : Colors.red) : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              curve: Curves.easeInOutCubic,
                              child: index == 0 ? 
                              Container(
                                width: MediaQuery.of(context).size.height * 0.1,
                                height: MediaQuery.of(context).size.height * 0.1,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey,
                                ),
                                child: CircleAvatar(
                                  foregroundImage: AssetImage(AIImages.icCheck2),
                                  backgroundColor: Colors.grey,
                                ),
                              ) :
                              CircleAvatar(
                                radius: MediaQuery.of(context).size.height * 0.05,
                                backgroundImage: AssetImage(viewModel.avatarTemplates[index]),
                              )

                            ),
                          ],
                        ),
                      ),
                    );
                  }
                )
              ) :
              Expanded(
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  controller: _pageController,
                  itemCount: viewModel.avatarVideos.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    return _VideoListItem(
                      index: index,
                      viewModel: viewModel,
                      onTap: () {
                        if (index == 0) return;
                        viewModel.handleTapImage(index, context);
                      },
                    );
                  }
                )
              ),                      
              SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: viewModel.togglePost,
                            child: Row(
                              children: [
                                Text("POST"),
                                SizedBox(width: 4.0),
                                Icon(viewModel.isPosting ? Icons.arrow_drop_up : Icons.arrow_drop_down)
                              ],
                            )
                          )
                        ]
                      ),
                    ),
                    SizedBox(height: 4.0),
                    if(viewModel.isPosting)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: viewModel.handleClickAddEmotions,
                            child: Container(
                              padding: EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(
                                  color: Colors.blue.shade500,
                                  width: 1.0,
                                ),
                              ),
                              child: Text("Add emotions")
                            )
                          ),
                          GestureDetector(
                            onTap: viewModel.handleClickPostAction,
                            child: Container(
                              padding: EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(
                                  color: Colors.blue.shade500,
                                  width: 1.0,
                                ),
                              ),
                              child: Text("Post")
                            )
                          ),
                
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(
                                  color: Colors.blue.shade500,
                                  width: 1.0,
                                ),
                              ),
                              child: Text("Save to gallery")
                            )
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(
                                  color: Colors.blue.shade500,
                                  width: 1.0,
                                ),
                              ),
                              child: Text("Cancel")
                            )
                          ),
                        ]
                      )
                  ],
                ),
              ),
              SizedBox(height: 12.0),
            ],
          ),
        ),
      )
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
        border: widget.isSelected ? Colors.red : Colors.transparent,
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
      return widget.fallbackAvatar.isNotEmpty ?
        Center(
          child: Image.memory(
            widget.fallbackAvatar,
            width: widget.width,
            height: widget.height, 
            fit: BoxFit.cover
          ),
        ) :
        AIImage(
          widget.fallbackFace,
          fit: BoxFit.cover,
          width: widget.width,
          height: widget.height,
        );
    }
  }
}

class _VideoListItem extends StatelessWidget {
  final int index;
  final RRCAvatarGenerationProvider viewModel;
  final VoidCallback onTap;

  const _VideoListItem({
    required this.index,
    required this.viewModel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.height * 0.1,
        height: MediaQuery.of(context).size.height * 0.1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: viewModel.tappedImage == index? (viewModel.isSelected ? Colors.green : Colors.red) : Colors.transparent,
                  width: 2,
                ),
              ),
              curve: Curves.easeInOutCubic,
              child: index == 0 ? CircleAvatar(
                radius: MediaQuery.of(context).size.height * 0.05,
                backgroundImage: viewModel.selectedAvatar == 0 ? FileImage(File(viewModel.avatarTemplates[viewModel.selectedAvatar])) : AssetImage(viewModel.avatarTemplates[viewModel.selectedAvatar]),
              ) : FutureBuilder<bool>(
                future: viewModel.validateVideoFile(viewModel.avatarVideos[index]),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      width: MediaQuery.of(context).size.height * 0.1 - 2,
                      height: MediaQuery.of(context).size.height * 0.1 - 2,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[300],
                      ),
                      child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                    );
                  }
                  
                  if (snapshot.hasData && snapshot.data == true) {
                      return _CachedVideoWidget(
                        path: viewModel.avatarVideos[index],
                        isSelected: viewModel.tappedImage == index,
                        radius: MediaQuery.of(context).size.height * 0.1 - 2,
                        onValidation: viewModel.validateVideoFile,
                      );
                  } else {
                    // Show placeholder for invalid video
                    return Container(
                      width: MediaQuery.of(context).size.height * 0.1 - 2,
                      height: MediaQuery.of(context).size.height * 0.1 - 2,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[300],
                        border: Border.all(
                          color: viewModel.tappedImage == index ? Colors.red : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Icon(Icons.video_library_outlined, color: Colors.grey[600]),
                    );
                  }
                }
              )
            )
          ]
        )
      )
    );
  }
}
