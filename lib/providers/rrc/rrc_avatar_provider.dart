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
  final RunwareService _runwareService = locator<RunwareService>();

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
    // Mapping required order: laugh, LOL, HOT, surprised
    {'emoji': '⚡', 'prompt': 'laugh'},
    {'emoji': '😂', 'prompt': 'LOL'},
    {'emoji': '🔥', 'prompt': 'HOT'},
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

  Future<String?> onApply() async {
    if (isBusy) return null;
    clearErrors();
    String? videoUrl;
    await runBusyFuture(() async {
      try {
        final prompt = emotions[selectedEmotionIndex]['prompt'] ?? 'laugh';
        // Preferred dashboard settings
        const width = 360; // 3:4 480p
        const height = 480;
        const fps = 24;
        const duration = 3;

        // Try to upload selfie for CDN URL, but fall back to local file if upload fails
        if (_selfieLocalPath.value == null || _selfieLocalPath.value!.isEmpty) {
          await pickSelfie();
        }
        try {
          await _ensureSelfieUploaded();
        } catch (_) {
          // Ignore upload failure and proceed with local file
        }

        String? url;
        if (_selfieCdnUrl.value != null && _selfieCdnUrl.value!.isNotEmpty) {
          url = await _runwareService.generateVideoFromImageUrl(
            imageUrl: _selfieCdnUrl.value!,
            prompt: prompt,
            width: width,
            height: height,
            fps: fps,
            durationSeconds: duration,
            model: 'bytedance:2@2',
          );
        } else if (_selfieLocalPath.value != null && _selfieLocalPath.value!.isNotEmpty) {
          url = await _runwareService.generateVideoFromFile(
            fileBytes: await File(_selfieLocalPath.value!).readAsBytes(),
            mimeType: 'image/jpeg',
            prompt: prompt,
            width: width,
            height: height,
            fps: fps,
            durationSeconds: duration,
            model: 'bytedance:2@2',
          );
        } else {
          throw Exception('Selfie is required');
        }
        if (url == null || url.isEmpty) {
          throw Exception('Runware returned empty result');
        }
        _generatedVideoUrl.value = videoUrl = url;
        AIHelpers.showToast(msg: 'Video ready!');
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


