import 'dart:io';

import 'package:flutter/material.dart';
import 'package:observable_ish/observable_ish.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/locator.dart';

class RRCAvatarProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext c) {
    _context = c;
    notifyListeners();
  }

  final AvatarService _avatarService = locator<AvatarService>();
  final RunwareService _runwareService = RunwareService();

  final RxValue<String?> _selfieLocalPath = RxValue<String?>(null);
  String? get selfieLocalPath => _selfieLocalPath.value;

  final RxValue<String?> _selfieCdnUrl = RxValue<String?>(null);
  String? get selfieCdnUrl => _selfieCdnUrl.value;

  final RxValue<int> _selectedAvatarIndex = RxValue<int>(0);
  int get selectedAvatarIndex => _selectedAvatarIndex.value;
  set selectedAvatarIndex(int i) {
    _selectedAvatarIndex.value = i;
    notifyListeners();
  }

  final RxValue<int> _selectedEmotionIndex = RxValue<int>(0);
  int get selectedEmotionIndex => _selectedEmotionIndex.value;
  set selectedEmotionIndex(int i) {
    _selectedEmotionIndex.value = i;
    notifyListeners();
  }

  final RxValue<String?> _generatedVideoUrl = RxValue<String?>(null);
  String? get generatedVideoUrl => _generatedVideoUrl.value;

  // Available emotions (emoji and short prompt hint)
  final List<Map<String, String>> emotions = [
    {'emoji': '⚡', 'prompt': 'energetic'},
    {'emoji': '😂', 'prompt': 'laugh'},
    {'emoji': '🔥', 'prompt': 'fire'},
    {'emoji': '😮', 'prompt': 'surprised'},
  ];

  // Fake avatar defs — index 0 is "My Face" (no avatar)
  // Subsequent items represent style prompts for avatar generation.
  final List<Map<String, String>> avatars = [
    {'label': 'My Face', 'prompt': ''},
    // Supplied avatar images (assets). Adjust prompts as needed.
    {'label': 'A', 'prompt': 'anime character, neon outline portrait', 'image': 'assets/images/rrc/avatar1.jpg'},
    {'label': 'B', 'prompt': '3d pixar style portrait, soft lighting', 'image': 'assets/images/rrc/avatar2.jpg'},
    {'label': 'C', 'prompt': 'anime portrait, clean line art style', 'image': 'assets/images/rrc/avatar3.jpg'},
    {'label': 'D', 'prompt': 'neon edge glow portrait, cyber look', 'image': 'assets/images/rrc/avatar4.jpg'},
  ];

  Future<void> init(BuildContext context) async {
    this.context = context;
  }

  Future<void> pickSelfie() async {
    try {
      final path = await _avatarService.pickCropImage(context, 0);
      if (path != null) {
        _selfieLocalPath.value = path;
        notifyListeners();
      }
    } catch (e, s) {
      logger.e('pickSelfie', error: e, stackTrace: s);
      AIHelpers.showToast(msg: 'Failed to capture selfie.');
    }
  }

  Future<void> _ensureSelfieUploaded() async {
    if (_selfieCdnUrl.value != null) return;
    if ((_selfieLocalPath.value ?? '').isEmpty) {
      await pickSelfie();
    }
    final path = _selfieLocalPath.value;
    if ((path ?? '').isEmpty) {
      throw Exception('Selfie is required');
    }
    final uploaded = await _avatarService.uploadOriginAvatar(File(path!));
    if (uploaded == null || uploaded.isEmpty) {
      throw Exception('Failed to upload selfie');
    }
    _selfieCdnUrl.value = uploaded;
    notifyListeners();
  }

  Future<String> _maybeCreateAvatarFromSelfie() async {
    await _ensureSelfieUploaded();
    if (selectedAvatarIndex == 0) {
      return _selfieCdnUrl.value!;
    }
    final prompt = avatars[selectedAvatarIndex]['prompt'] ?? '';
    final taskId = await _avatarService.createTask(
      fileUrl: _selfieCdnUrl.value!,
      prompt: prompt,
      size: '1024x1024',
    );
    if (taskId == null) throw Exception('Failed to create avatar task');
    final task = await _avatarService.setOnProgressListener(
      taskId,
      onProgressListener: (p) {},
    );
    final imageUrl = await _avatarService.downloadAvatar(
      taskId,
      url: task['result'] ?? (task['url'] ?? ''),
    );
    if (imageUrl == null || imageUrl.isEmpty) {
      throw Exception('Failed to download generated avatar');
    }
    final cdnUrl = await _avatarService.uploadResultAvatar(imageUrl);
    if (cdnUrl == null || cdnUrl.isEmpty) {
      throw Exception('Failed to upload avatar to CDN');
    }
    return cdnUrl;
  }

  Future<String?> onApply() async {
    if (isBusy) return null;
    clearErrors();
    String? videoUrl;
    await runBusyFuture(() async {
      try {
        // 1) Ensure we have a selfie URL (and optionally create avatar)
        final imageForVideo = await _maybeCreateAvatarFromSelfie();

        // 2) Trigger image-to-video
        final emotionPrompt = emotions[selectedEmotionIndex]['prompt'] ?? '';
        final task = await _runwareService.createImageToVideo(
          imageUrl: imageForVideo,
          prompt: 'emotion: $emotionPrompt, loopable dance animation',
          durationSeconds: 5,
        );

        // 3) If task returns an id, poll it. Else if includes url, use directly.
        if ((task['id'] ?? '').toString().isNotEmpty) {
          final finalTask = await _runwareService.pollTask(task['id'].toString());
          videoUrl = (finalTask['result'] ?? finalTask['url'] ?? '').toString();
        } else {
          videoUrl = (task['result'] ?? task['url'] ?? '').toString();
        }

        if ((videoUrl ?? '').isEmpty) {
          throw Exception('Video generation did not return a URL');
        }

        _generatedVideoUrl.value = videoUrl;
        AIHelpers.showToast(msg: 'Your Vybe Loop is generating!');
        // In the future, navigate to a preview/detail page if needed.
      } catch (e, s) {
        setError(e);
        logger.e(e, stackTrace: s);
      } finally {
        notifyListeners();
      }
    }());

    if (hasError) {
      AIHelpers.showToast(msg: modelError.toString());
    }
    return videoUrl;
  }
}


