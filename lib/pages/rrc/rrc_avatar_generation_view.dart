import 'package:flutter/material.dart';
import 'dart:io';
import 'package:stacked/stacked.dart';
import 'package:insoblok/services/services.dart';

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

  Future<void> _onApplyPressed(RRCAvatarProvider vm) async {
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
        // Debug logging for video URL
        if (vm.generatedVideoUrl != null) {
          logger.d('Video URL in view: ${vm.generatedVideoUrl}');
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
                  const SizedBox(height: 16),
                  Text(
                    'CHOOSE YOUR\nENERGY',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      height: 1.1,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 24),
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
                                borderRadius: BorderRadius.circular(16),
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
                              child: AIImage(
                                vm.generatedImageUrl!,
                                width: 280,
                                height: 280,
                                fit: BoxFit.cover,
                              ),
                            )
                            // For dashboard: prioritize video over avatar image
                            // Show video if available, otherwise show avatar image if available
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
                            // Show placeholder with "Creating video..." if avatar is ready but video is being generated
                            : (vm.origin == "dashboard" &&
                                vm.generatedAvatarImageUrl != null &&
                                vm.generatedAvatarImageUrl!.isNotEmpty &&
                                vm.isBusy)
                            ? Container(
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
                                  border: Border.all(
                                    width: 2,
                                    color: Colors.white.withOpacity(0.1),
                                  ),
                                ),
                                child: const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        'Creating video...',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
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
                  // Emojis for dashboard/story page (always show for dashboard)
                  if (vm.origin != "profile") ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(vm.emotions.length, (i) {
                        final isSel = vm.selectedEmotionIndex == i;
                        return GestureDetector(
                          onTap: () => vm.selectedEmotionIndex = i,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isSel
                                      ? Colors.white.withOpacity(0.10)
                                      : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSel ? Colors.white : Colors.white12,
                                width: 2,
                              ),
                            ),
                            child: Text(
                              vm.emotions[i]['emoji']!,
                              style: const TextStyle(fontSize: 40),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 18),
                  ],
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
                            child: Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color:
                                      vm.selectedAvatarIndex == 0
                                          ? Colors.white
                                          : Colors.white24,
                                  width: 3,
                                ),
                              ),
                              child: ClipOval(
                                child:
                                    vm.capturedFacePath != null &&
                                            File(
                                              vm.capturedFacePath!,
                                            ).existsSync()
                                        ? GestureDetector(
                                          onTap: vm.pickSelfie,
                                          child: Image.file(
                                            File(vm.capturedFacePath!),
                                            key: ValueKey(vm.capturedFacePath),
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
                                            key: ValueKey(vm.selfieLocalPath),
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
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: vm.avatars.length - 1,
                              separatorBuilder:
                                  (_, __) => const SizedBox(width: 10),
                              itemBuilder: (context, idx) {
                                final i = idx + 1; // shift (skip "My Face")
                                final isSel = vm.selectedAvatarIndex == i;
                                final label = vm.avatars[i]['label']!;
                                final img =
                                    (vm.avatars[i]['image'] ?? '').toString();
                                return GestureDetector(
                                  onTap: () => vm.selectedAvatarIndex = i,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 48,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white10,
                                          border: Border.all(
                                            color:
                                                isSel
                                                    ? Colors.white
                                                    : Colors.white24,
                                            width: 2,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child:
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
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
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
                  const SizedBox(height: 16),
                  // Apply button
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: TextFillButton(
                      onTap: () => _onApplyPressed(vm),
                      isBusy: vm.isBusy,
                      height: 48,
                      text:
                          (vm.origin == "profile" &&
                                      vm.generatedImageUrl != null) ||
                                  (vm.origin != "profile" &&
                                      vm.generatedVideoUrl != null)
                              ? (vm.origin == "profile"
                                  ? 'Save'
                                  : 'Post Reaction')
                              : 'Apply',
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
