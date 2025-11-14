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

  final RxValue<String?> _generatedImageUrl = RxValue<String?>(null);
  String? get generatedImageUrl => _generatedImageUrl.value;

  String? _origin;
  String? get origin => _origin;
  set origin(String? s) {
    _origin = s;
    notifyListeners();
  }

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
    {
      'label': 'A',
      'prompt': 'anime character, neon outline portrait',
      'image': 'assets/images/rrc/avatar1.jpg',
    },
    {
      'label': 'B',
      'prompt': '3d pixar style portrait, soft lighting',
      'image': 'assets/images/rrc/avatar2.jpg',
    },
    {
      'label': 'C',
      'prompt': 'anime portrait, clean line art style',
      'image': 'assets/images/rrc/avatar3.jpg',
    },
    {
      'label': 'D',
      'prompt': 'neon edge glow portrait, cyber look',
      'image': 'assets/images/rrc/avatar4.jpg',
    },
  ];

  Future<void> init(
    BuildContext context,
    String origin, {
    String? initialImagePath,
  }) async {
    this.context = context;
    this.origin = origin;
    if (initialImagePath != null && initialImagePath.isNotEmpty) {
      _selfieLocalPath.value = initialImagePath;
      notifyListeners();
    }
    logger.d(
      "RRCAvatarProvider initialized with origin: $origin, initialImagePath: $initialImagePath",
    );
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

    if (_selfieLocalPath.value == null || _selfieLocalPath.value!.isEmpty) {
      AIHelpers.showToast(msg: 'Please select a selfie first');
      return null;
    }

    String? resultUrl;
    await runBusyFuture(() async {
      try {
        String? imageUrl;
        try {
          await _ensureSelfieUploaded();
          imageUrl = _selfieCdnUrl.value;
        } catch (e) {
          logger.e('Failed to upload selfie to Cloudinary: $e');
          throw Exception('Failed to upload selfie. Please try again.');
        }

        if (imageUrl == null || imageUrl.isEmpty) {
          throw Exception(
            'Selfie URL is required. Please ensure your selfie is uploaded.',
          );
        }

        // Use different Runware methods based on origin
        if (origin == "dashboard" || origin == null) {
          // From story page - generate emotion video
          final prompt = emotions[selectedEmotionIndex]['prompt'] ?? 'laugh';
          logger.d(
            'Generating video with Cloudinary image: $imageUrl, prompt: $prompt',
          );

          final result = await _runwareService.generateAIEmotionVideoWithPrompt(
            inputImage: imageUrl,
            positivePrompt: prompt,
          );

          if (result['status'] == 'success' && result['success'] == true) {
            final generatedVideoUrl = result['videoURL'] as String?;
            if (generatedVideoUrl != null && generatedVideoUrl.isNotEmpty) {
              _generatedVideoUrl.value = resultUrl = generatedVideoUrl;
              AIHelpers.showToast(msg: 'Video ready!');
            } else {
              throw Exception('Video URL not found in response');
            }
          } else if (result['status'] == 'processing') {
            logger.w(
              'Video is still processing. Task UUID: ${result['taskUUID']}',
            );
            throw Exception(
              'Video generation is still processing. Please wait and try again.',
            );
          } else {
            final errorMsg = result['message'] ?? 'Unknown error occurred';
            logger.e('Video generation failed: $errorMsg');
            throw Exception('Video generation failed: $errorMsg');
          }
        } else if (origin == "profile") {
          // From profile page - generate AI avatar image
          final prompt =
              selectedAvatarIndex > 0 && selectedAvatarIndex < avatars.length
                  ? avatars[selectedAvatarIndex]['prompt'] ??
                      'high quality portrait'
                  : 'high quality portrait, professional photography';

          logger.d(
            'Generating avatar with Cloudinary image: $imageUrl, prompt: $prompt',
          );

          final result = await _runwareService
              .generateAIAvatarWithPromptOption1(
                inputImage: imageUrl,
                positivePrompt: prompt,
              );

          if (result['status'] == 'success' && result['success'] == true) {
            final generatedImageUrl = result['imageURL'] as String?;
            if (generatedImageUrl != null && generatedImageUrl.isNotEmpty) {
              _generatedImageUrl.value = resultUrl = generatedImageUrl;
              AIHelpers.showToast(msg: 'Avatar ready!');
            } else {
              throw Exception('Image URL not found in response');
            }
          } else if (result['status'] == 'processing') {
            logger.w(
              'Avatar is still processing. Task UUID: ${result['taskUUID']}',
            );
            throw Exception(
              'Avatar generation is still processing. Please wait and try again.',
            );
          } else {
            final errorMsg = result['message'] ?? 'Unknown error occurred';
            logger.e('Avatar generation failed: $errorMsg');
            throw Exception('Avatar generation failed: $errorMsg');
          }
        }
      } catch (e) {
        setError(e);
        logger.e('Error generating content: $e');
      } finally {
        notifyListeners();
      }
    }());

    if (hasError) {
      AIHelpers.showToast(msg: modelError.toString());
    }

    return resultUrl;
  }
}
