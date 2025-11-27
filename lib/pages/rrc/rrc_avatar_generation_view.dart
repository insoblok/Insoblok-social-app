import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:math';
import 'package:stacked/stacked.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

import 'package:insoblok/providers/rrc/rrc_avatar_provider.dart';
import 'package:insoblok/widgets/widgets.dart';

class RRCAvatarGenerationView extends StatefulWidget {
  final String? origin;
  final File? initialImage;
  final String? storyID;
  final String? url;
  const RRCAvatarGenerationView({
    super.key,
    this.origin,
    this.initialImage,
    this.storyID,
    this.url,
  });

  @override
  State<RRCAvatarGenerationView> createState() =>
      _RRCAvatarGenerationViewState();
}

class _RRCAvatarGenerationViewState extends State<RRCAvatarGenerationView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _rotationController;
  int? _countdown; // null => idle
  bool _didAutoStart = false;
  bool _showLoadingVideo =
      false; // Show loading video after countdown until emotion video is ready
  int _loadingVideoKey =
      0; // Counter to force video widget recreation when needed
  String? _selectedLoadingVideoPath; // Randomly selected loading video path

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  bool get _isCountingDown => _countdown != null;

  String _getRandomLoadingVideo() {
    final random = Random();
    final videoNumber = random.nextInt(3) + 1; // Random number between 1 and 3
    return 'assets/videos/loading$videoNumber.mp4';
  }

  void _startCountdown(RRCAvatarProvider vm) {
    if (_isCountingDown) return;
    setState(() {
      _countdown = 3;
    });
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      final current = _countdown ?? 0;
      if (current <= 1) {
        setState(() {
          _countdown = null;
          // Don't show loading video here - it will show when Apply is clicked or when generating emotion video
        });
        // Capture face automatically at the end using camera
        vm.captureReactionImage();
        return false;
      }
      setState(() {
        _countdown = current - 1;
      });
      return true;
    });
  }

  String _getTitleText(RRCAvatarProvider vm) {
    // Before taking selfie
    if ((vm.selfieLocalPath == null || vm.selfieLocalPath!.isEmpty) &&
        (vm.capturedFacePath == null || vm.capturedFacePath!.isEmpty)) {
      return 'HOLD STILL POWERING\nYOUR VYBE';
    }

    // After face is captured but before creating emotion/avatar (not busy, no generated content yet)
    if ((vm.capturedFacePath != null && vm.capturedFacePath!.isNotEmpty) &&
        !vm.isBusy &&
        ((vm.origin == "profile" && vm.generatedImageUrl == null) ||
            (vm.origin != "profile" &&
                vm.generatedVideoUrl == null &&
                vm.generatedAvatarImageUrl == null))) {
      // For profile mode, show "SELECT YOUR AVATAR", for dashboard show "SELECTION YOUR EMOTION"
      return vm.origin == "profile"
          ? 'SELECT YOUR AVATAR'
          : 'SELECTION YOUR EMOTION';
    }

    // When video is ready and playing (dashboard mode)
    if (vm.origin == "dashboard" &&
        vm.generatedVideoUrl != null &&
        vm.generatedVideoUrl!.isNotEmpty &&
        !vm.isBusy) {
      return 'PLAYING EMOTION GIT';
    }

    // When creating/loading video (avatar image exists but video not ready yet)
    if (vm.isBusy &&
        vm.origin == "dashboard" &&
        vm.generatedAvatarImageUrl != null &&
        vm.generatedAvatarImageUrl!.isNotEmpty &&
        (vm.generatedVideoUrl == null || vm.generatedVideoUrl!.isEmpty)) {
      return 'CREATING EMOTION GIF';
    }

    // When loading/processing
    if (vm.isBusy) {
      // For profile mode, show "CREATING AVATAR", for dashboard show "CREATING EMOTION"
      return vm.origin == "profile" ? 'CREATING AVATAR' : 'CREATING EMOTION';
    }

    // When avatar is generated in profile mode
    if (vm.origin == "profile" &&
        vm.generatedImageUrl != null &&
        vm.generatedImageUrl!.isNotEmpty) {
      return 'SAVE YOUR AVATAR';
    }

    // Default: when video is ready or other states
    // return 'HOLD STILL POWERING\nYOUR VYBE';

    return vm.origin == "profile"
        ? 'SELECT YOUR AVATAR'
        : 'HOLD STILL POWERING\nYOUR VYBE';
  }

  Future<void> _onApplyPressed(RRCAvatarProvider vm) async {
    // Check if avatar is selected (index 0 means "My Face" - no avatar)
    if (vm.selectedAvatarIndex == 0) {
      AIHelpers.showToast(msg: "Please select the avatar.");
      return;
    }

    // Show loading video when Apply button is clicked (before generating avatar/video)
    // Set loading video state immediately to show the video widget
    // Increment key counter to force video widget recreation and immediate playback
    setState(() {
      _showLoadingVideo = true;
      _selectedLoadingVideoPath =
          _getRandomLoadingVideo(); // Select random loading video
      _loadingVideoKey++; // Force recreation of video widget
    });

    // Ensure the widget is built before proceeding
    await Future.delayed(const Duration(milliseconds: 50));

    if (vm.origin == "profile") {
      if (vm.generatedImageUrl == null) {
        await vm.onApply();
        // button text will flip automatically via ViewModel rebuild
      } else {
        // Avatar is ready, navigate back with the result
        Navigator.of(context).pop(vm.generatedImageUrl);
      }
    } else {
      if (vm.generatedVideoUrl == null) {
        await vm.onApply();
        // button text will flip automatically via ViewModel rebuild
      } else {
        // Post the reaction video to the story
        await vm.postAsReaction();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RRCAvatarProvider>.reactive(
      viewModelBuilder: () => RRCAvatarProvider(),
      onViewModelReady:
          (vm) => vm.init(
            context,
            widget.origin ?? "dashboard",
            initialImagePath: widget.initialImage?.path,
            storyID: widget.storyID,
            url: widget.url,
          ),
      builder: (context, vm, _) {
        // Show loading video when busy creating avatar/video
        // Only show if face has been captured (not during "HOLD STILL POWERING YOUR VYBE")
        if (vm.isBusy &&
            !_showLoadingVideo &&
            (vm.capturedFacePath != null && vm.capturedFacePath!.isNotEmpty)) {
          // For dashboard mode: show when generating emotion video
          // For profile mode: show when generating avatar
          final shouldShow =
              (vm.origin == "dashboard" &&
                  (vm.generatedVideoUrl == null ||
                      vm.generatedVideoUrl!.isEmpty)) ||
              (vm.origin == "profile" &&
                  (vm.generatedImageUrl == null ||
                      vm.generatedImageUrl!.isEmpty));

          if (shouldShow) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  _showLoadingVideo = true;
                  _selectedLoadingVideoPath =
                      _getRandomLoadingVideo(); // Select random loading video
                });
              }
            });
          }
        }

        // Hide loading video when avatar/video is ready
        if (((vm.origin == "dashboard" &&
                    vm.generatedVideoUrl != null &&
                    vm.generatedVideoUrl!.isNotEmpty) ||
                (vm.origin == "profile" &&
                    vm.generatedImageUrl != null &&
                    vm.generatedImageUrl!.isNotEmpty)) &&
            _showLoadingVideo) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _showLoadingVideo = false;
              });
            }
          });
        }

        if (!_didAutoStart) {
          _didAutoStart = true;
          // Auto start RRC countdown when page appears (only if no initial image)
          if (widget.initialImage == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) _startCountdown(vm);
            });
          }
        }
        final Color bgTop = const Color(0xFF0B0C1E);
        final Color bgBottom = const Color(0xFF05060F);
        final List<Color> glow = [
          const Color(0xFF00C2FF),
          const Color(0xFF7A00F8),
          const Color(0xFFFF2DAE),
        ];

        return Scaffold(
          backgroundColor: bgBottom,
          body: SafeArea(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [bgTop, bgBottom],
                ),
              ),

              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Text(
                    _getTitleText(vm),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      height: 1.1,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Glowing bubble
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Outer rotating glow ring (bigger)
                        RotationTransition(
                          turns: _rotationController,
                          child: Container(
                            width: 340,
                            height: 340,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: SweepGradient(
                                colors: glow,
                                stops: const [0.0, 0.55, 1.0],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: glow[0].withOpacity(0.25),
                                  blurRadius: 48,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Inner content: either bubble placeholder, generated video, or generated avatar image
                        (vm.origin == "profile" && vm.generatedImageUrl != null)
                            ? Container(
                              width: 280,
                              height: 280,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white24,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 16,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: ClipOval(
                                child: AIImage(
                                  vm.generatedImageUrl!,
                                  width: 280,
                                  height: 280,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                            // For dashboard: prioritize video over avatar image
                            // Show video if available, otherwise show loading video or avatar image if available
                            : (vm.generatedVideoUrl != null &&
                                vm.generatedVideoUrl!.isNotEmpty)
                            ? Container(
                              width: 280,
                              height: 280,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white24,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 16,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  VideoPlayerWidget(
                                    key: ValueKey(vm.generatedVideoUrl),
                                    path: vm.generatedVideoUrl!,
                                    border: Colors.transparent,
                                    circular: true,
                                    radius: 280,
                                  ),
                                  // Show loading indicator while video is initializing
                                  if (vm.isBusy)
                                    Container(
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black54,
                                      ),
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            )
                            // Show loading video when "CREATING AVATAR" or "CREATING EMOTION" is displayed
                            // Show loading video when:
                            // 1. _showLoadingVideo flag is true (set when Apply is clicked), OR
                            // 2. vm.isBusy is true (when actually creating avatar/video)
                            // For profile mode: show when creating avatar (generatedImageUrl is null)
                            // For dashboard mode: show when creating emotion video (generatedVideoUrl is null)
                            // Only show if face has been captured (not during "HOLD STILL POWERING YOUR VYBE")
                            : (vm.capturedFacePath != null &&
                                    vm.capturedFacePath!.isNotEmpty) &&
                                ((_showLoadingVideo || vm.isBusy) &&
                                    ((vm.origin == "profile" &&
                                            (vm.generatedImageUrl == null ||
                                                vm
                                                    .generatedImageUrl!
                                                    .isEmpty)) ||
                                        (vm.origin == "dashboard" &&
                                            (vm.generatedVideoUrl == null ||
                                                vm
                                                    .generatedVideoUrl!
                                                    .isEmpty))))
                            ? Stack(
                              alignment: Alignment.center,
                              children: [
                                // Video player with proper circular clipping
                                ClipOval(
                                  clipBehavior: Clip.antiAlias,
                                  child: SizedBox(
                                    width: 280,
                                    height: 280,
                                    child: VideoPlayerWidget(
                                      key: ValueKey(
                                        'loading_video_${_showLoadingVideo}_${_loadingVideoKey}_${_selectedLoadingVideoPath}',
                                      ),
                                      path:
                                          _selectedLoadingVideoPath ??
                                          'assets/videos/loading1.mp4',
                                      border: Colors.transparent,
                                      circular: true,
                                      radius: 280,
                                      width: 280,
                                      height: 280,
                                    ),
                                  ),
                                ),
                                // Border decoration overlay
                                Container(
                                  width: 280,
                                  height: 280,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white24,
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        blurRadius: 16,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                            : Container(
                              width: 300,
                              height: 300,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    const Color(0xFF0F1735),
                                    const Color(0xFF0B0F25),
                                  ],
                                ),
                                border: Border.all(
                                  width: 10,
                                  color: Colors.white.withOpacity(0.06),
                                ),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      glow[0].withOpacity(0.10),
                                      Colors.transparent,
                                    ],
                                    radius: 0.65,
                                  ),
                                ),
                              ),
                            ),
                        if (_isCountingDown)
                          Text(
                            '${_countdown ?? ''}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 96,
                              fontWeight: FontWeight.w900,
                              height: 1.0,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Avatars pill row (show for both profile and dashboard)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Container(
                      height: 86,
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: Colors.white12, width: 1.5),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          // Left: large "My Face" slot
                          GestureDetector(
                            onTap: () => vm.selectedAvatarIndex = 0,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    vm.selectedAvatarIndex == 0
                                        ? Colors.white.withOpacity(0.2)
                                        : Colors.transparent,
                                border: Border.all(
                                  color: Colors.white,
                                  width: vm.selectedAvatarIndex == 0 ? 3 : 2,
                                ),
                                boxShadow:
                                    vm.selectedAvatarIndex == 0
                                        ? [
                                          BoxShadow(
                                            color: Colors.white.withOpacity(
                                              0.4,
                                            ),
                                            blurRadius: 8,
                                            spreadRadius: 1,
                                          ),
                                        ]
                                        : null,
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                clipBehavior: Clip.none,
                                children: [
                                  ClipOval(
                                    child:
                                        vm.capturedFacePath != null &&
                                                File(
                                                  vm.capturedFacePath!,
                                                ).existsSync()
                                            ? GestureDetector(
                                              onTap: vm.pickSelfie,
                                              child: Image.file(
                                                File(vm.capturedFacePath!),
                                                key: ValueKey(
                                                  vm.capturedFacePath,
                                                ),
                                                fit: BoxFit.cover,
                                                errorBuilder: (
                                                  context,
                                                  error,
                                                  stackTrace,
                                                ) {
                                                  logger.e(
                                                    'Error loading captured face: $error',
                                                  );
                                                  return IconButton(
                                                    icon: const Icon(
                                                      Icons.add_a_photo,
                                                      color: Colors.white70,
                                                    ),
                                                    onPressed: vm.pickSelfie,
                                                  );
                                                },
                                              ),
                                            )
                                            : vm.selfieLocalPath != null &&
                                                File(
                                                  vm.selfieLocalPath!,
                                                ).existsSync()
                                            ? GestureDetector(
                                              onTap: vm.pickSelfie,
                                              child: Image.file(
                                                File(vm.selfieLocalPath!),
                                                key: ValueKey(
                                                  vm.selfieLocalPath,
                                                ),
                                                fit: BoxFit.cover,
                                                errorBuilder: (
                                                  context,
                                                  error,
                                                  stackTrace,
                                                ) {
                                                  logger.e(
                                                    'Error loading selfie: $error',
                                                  );
                                                  return IconButton(
                                                    icon: const Icon(
                                                      Icons.add_a_photo,
                                                      color: Colors.white70,
                                                    ),
                                                    onPressed: vm.pickSelfie,
                                                  );
                                                },
                                              ),
                                            )
                                            : IconButton(
                                              icon: const Icon(
                                                Icons.add_a_photo,
                                                color: Colors.white70,
                                              ),
                                              onPressed: vm.pickSelfie,
                                            ),
                                  ),
                                  if (vm.selectedAvatarIndex == 0)
                                    Positioned(
                                      top: -2,
                                      right: -2,
                                      child: Container(
                                        key: const ValueKey('my-face-check'),
                                        width: 18,
                                        height: 18,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                        ),
                                        child: const Icon(
                                          Icons.check,
                                          size: 12,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: vm.avatars.length - 1,
                              separatorBuilder:
                                  (_, __) => const SizedBox(width: 15),
                              itemBuilder: (context, idx) {
                                final i = idx + 1; // shift (skip "My Face")
                                final isSel = vm.selectedAvatarIndex == i;
                                final label = vm.avatars[i]['label']!;
                                final img =
                                    (vm.avatars[i]['image'] ?? '').toString();
                                // Color cycle: yellow, blue, purple for unselected items
                                final List<Color> unselectedColors = [
                                  Colors.yellow,
                                  Colors.blue,
                                  Colors.purple,
                                ];
                                final Color borderColor =
                                    isSel
                                        ? Colors.white
                                        : unselectedColors[idx %
                                            unselectedColors.length];
                                return GestureDetector(
                                  onTap: () => vm.selectedAvatarIndex = i,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 150,
                                        ),
                                        width: 48,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color:
                                              isSel
                                                  ? Colors.white.withOpacity(
                                                    0.2,
                                                  )
                                                  : Colors.white10,
                                          border: Border.all(
                                            color: borderColor,
                                            width: isSel ? 3 : 2,
                                          ),
                                          boxShadow:
                                              isSel
                                                  ? [
                                                    BoxShadow(
                                                      color: Colors.white
                                                          .withOpacity(0.4),
                                                      blurRadius: 8,
                                                      spreadRadius: 1,
                                                    ),
                                                  ]
                                                  : null,
                                        ),
                                        alignment: Alignment.center,
                                        child: Stack(
                                          alignment: Alignment.center,
                                          clipBehavior: Clip.none,
                                          children: [
                                            img.isNotEmpty
                                                ? ClipOval(
                                                  child: Image.asset(
                                                    img,
                                                    width: 48,
                                                    height: 48,
                                                    fit: BoxFit.cover,
                                                  ),
                                                )
                                                : Text(
                                                  label.characters.first,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: isSel ? 20 : 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                            if (isSel)
                                              Positioned(
                                                top: -2,
                                                right: -2,
                                                child: Container(
                                                  key: ValueKey(
                                                    'avatar-check-$i',
                                                  ),
                                                  width: 16,
                                                  height: 16,
                                                  decoration:
                                                      const BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.white,
                                                      ),
                                                  child: const Icon(
                                                    Icons.check,
                                                    size: 11,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Emojis for dashboard/story page (always show for dashboard)
                  if (vm.origin != "profile") ...[
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(vm.emotions.length, (i) {
                        final isSel = vm.selectedEmotionIndex == i;
                        final emotion = vm.emotions[i];
                        // Color cycle: yellow, blue, purple for unselected items
                        final List<Color> unselectedColors = [
                          Colors.yellow,
                          Colors.blue,
                          Colors.purple,
                        ];
                        final Color borderColor =
                            isSel
                                ? Colors.white
                                : unselectedColors[i % unselectedColors.length];
                        return GestureDetector(
                          onTap: () => vm.selectedEmotionIndex = i,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      isSel
                                          ? Colors.white.withOpacity(0.15)
                                          : Colors.transparent,
                                  border: Border.all(
                                    color: borderColor,
                                    width: isSel ? 4 : 3,
                                  ),
                                  boxShadow:
                                      isSel
                                          ? [
                                            BoxShadow(
                                              color: Colors.white.withOpacity(
                                                0.3,
                                              ),
                                              blurRadius: 12,
                                              spreadRadius: 2,
                                            ),
                                          ]
                                          : null,
                                ),
                                child: Center(
                                  child: Stack(
                                    alignment: Alignment.center,
                                    clipBehavior: Clip.none,
                                    children: [
                                      Text(
                                        emotion['emoji']!,
                                        style: TextStyle(
                                          fontSize: isSel ? 42 : 40,
                                        ),
                                      ),
                                      if (isSel)
                                        Positioned(
                                          top: -2,
                                          right: -2,
                                          child: Container(
                                            width: 20,
                                            height: 20,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                            ),
                                            child: const Icon(
                                              Icons.check,
                                              size: 14,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ],

                  const SizedBox(height: 16),
                  // Apply button
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Builder(
                      builder: (context) {
                        // Check if emotion, avatar, and captured face are selected
                        // selectedAvatarIndex > 0 means avatar is selected (0 is "My Face")
                        // selectedEmotionIndex is always valid (starts at 0, which is first emotion)
                        // capturedFacePath must not be null or empty
                        final bool isEmotionAndAvatarSelected =
                            vm.selectedAvatarIndex > 0 &&
                            vm.selectedEmotionIndex >= 0 &&
                            vm.selectedEmotionIndex < vm.emotions.length &&
                            (vm.capturedFacePath != null &&
                                vm.capturedFacePath!.isNotEmpty);

                        // Check if avatar template is selected (for profile mode, just check avatar; for dashboard, check both)
                        final bool isAvatarSelected =
                            vm.origin == "profile"
                                ? vm.selectedAvatarIndex > 0
                                : isEmotionAndAvatarSelected;

                        final String buttonText =
                            (vm.origin == "profile" &&
                                        vm.generatedImageUrl != null) ||
                                    (vm.origin != "profile" &&
                                        vm.generatedVideoUrl != null)
                                ? (vm.origin == "profile"
                                    ? 'Save'
                                    : 'Post Reaction')
                                : 'Apply';

                        // Use pink button if avatar template is selected, grey otherwise
                        if (isAvatarSelected) {
                          return TextFillButton(
                            onTap: () => _onApplyPressed(vm),
                            isBusy: vm.isBusy,
                            height: 48,
                            color: AIColors.pink,
                            text: buttonText,
                          );
                        } else {
                          return TextFillButton(
                            onTap: () => _onApplyPressed(vm),
                            isBusy: vm.isBusy,
                            height: 48,
                            color: Colors.grey,
                            text: buttonText,
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
