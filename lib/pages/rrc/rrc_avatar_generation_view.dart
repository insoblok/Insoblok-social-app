import 'package:flutter/material.dart';
import 'dart:io';
import 'package:stacked/stacked.dart';
import 'package:insoblok/utils/utils.dart';

import 'package:insoblok/providers/rrc/rrc_avatar_provider.dart';
import 'package:insoblok/widgets/widgets.dart';

class RRCAvatarGenerationView extends StatefulWidget {
  const RRCAvatarGenerationView({super.key});

  @override
  State<RRCAvatarGenerationView> createState() => _RRCAvatarGenerationViewState();
}

class _RRCAvatarGenerationViewState extends State<RRCAvatarGenerationView> with SingleTickerProviderStateMixin {
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
        // Take selfie automatically at the end
        vm.pickSelfie();
        return false;
      }
      setState(() {
        _countdown = current - 1;
      });
      return true;
    });
  }

  Future<void> _onApplyPressed(RRCAvatarProvider vm) async {
    if (vm.generatedVideoUrl == null) {
      await vm.onApply();
      // button text will flip automatically via ViewModel rebuild
    } else {
      AIHelpers.showToast(msg: 'Ready to post reaction.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RRCAvatarProvider>.reactive(
      viewModelBuilder: () => RRCAvatarProvider(),
      onViewModelReady: (vm) => vm.init(context),
      builder: (context, vm, _) {
        if (!_didAutoStart) {
          _didAutoStart = true;
          // Auto start RRC countdown when page appears
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _startCountdown(vm);
          });
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
                        // Inner content: either bubble placeholder or generated video preview
                        vm.generatedVideoUrl == null
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
                                    gradient: RadialGradient(
                                      colors: [
                                        glow[0].withOpacity(0.10),
                                        Colors.transparent
                                      ],
                                      radius: 0.65,
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox(
                                width: 300,
                                height: 300,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // keep same subtle inner ring styling behind the video
                                    Container(
                                      width: 300,
                                      height: 300,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: RadialGradient(
                                          colors: [
                                            glow[0].withOpacity(0.10),
                                            Colors.transparent
                                          ],
                                          radius: 0.65,
                                        ),
                                        border: Border.all(
                                          width: 10,
                                          color: Colors.white.withOpacity(0.06),
                                        ),
                                      ),
                                    ),
                                    // video clipped to a circle, slightly inset (280) to respect the 10px ring
                                    VideoPlayerWidget(
                                      path: vm.generatedVideoUrl!,
                                      border: Colors.transparent,
                                      circular: true,
                                      radius: 280,
                                    ),
                                  ],
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
                  // Emojis
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
                            color: isSel ? Colors.white.withOpacity(0.10) : Colors.transparent,
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
                  // Avatars pill row
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Container(
                      height: 86,
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: Colors.white12, width: 1.5),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                                  color: vm.selectedAvatarIndex == 0 ? Colors.white : Colors.white24,
                                  width: 3,
                                ),
                              ),
                              child: ClipOval(
                                child: vm.selfieLocalPath == null
                                    ? IconButton(
                                        icon: const Icon(Icons.add_a_photo, color: Colors.white70),
                                        onPressed: vm.pickSelfie,
                                      )
                                    : Image.file(
                                        File(vm.selfieLocalPath!),
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: vm.avatars.length - 1,
                              separatorBuilder: (_, __) => const SizedBox(width: 10),
                              itemBuilder: (context, idx) {
                                final i = idx + 1; // shift (skip "My Face")
                                final isSel = vm.selectedAvatarIndex == i;
                                final label = vm.avatars[i]['label']!;
                                final img = (vm.avatars[i]['image'] ?? '').toString();
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
                                            color: isSel ? Colors.white : Colors.white24,
                                            width: 2,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: img.isNotEmpty
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
                      text: vm.generatedVideoUrl == null ? 'Apply' : 'Post Reaction',
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


