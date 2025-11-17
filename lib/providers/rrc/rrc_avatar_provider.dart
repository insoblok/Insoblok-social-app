import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:observable_ish/observable_ish.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/locator.dart';
import 'package:insoblok/utils/background_camera_capture.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insoblok/services/cloudinary_cdn_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;
import 'package:insoblok/routers/navigation.dart';

class RRCAvatarProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext c) {
    _context = c;
    notifyListeners();
  }

  final AvatarService _avatarService = locator<AvatarService>();
  final RunwareService _runwareService = locator<RunwareService>();
  // storyService is already available from InSoBlokViewModel base class

  final camera = BackgroundCameraCapture(maxCaptures: 1, stopStreamOnMax: true);

  final RxValue<String?> _selfieLocalPath = RxValue<String?>(null);
  String? get selfieLocalPath => _selfieLocalPath.value;

  final RxValue<String?> _capturedFacePath = RxValue<String?>(null);
  String? get capturedFacePath => _capturedFacePath.value;

  bool _isCapturingFace = false;
  bool get isCapturingFace => _isCapturingFace;

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

  // Store the generated avatar image URL when avatar is selected for dashboard flow
  final RxValue<String?> _generatedAvatarImageUrl = RxValue<String?>(null);
  String? get generatedAvatarImageUrl => _generatedAvatarImageUrl.value;

  String? _origin;
  String? get origin => _origin;
  set origin(String? s) {
    _origin = s;
    notifyListeners();
  }

  String? _storyID;
  String? get storyID => _storyID;
  set storyID(String? s) {
    _storyID = s;
    notifyListeners();
  }

  String? _url;
  String? get url => _url;
  set url(String? s) {
    _url = s;
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
    String? storyID,
    String? url,
  }) async {
    this.context = context;
    this.origin = origin;
    this.storyID = storyID;
    this.url = url;
    if (initialImagePath != null && initialImagePath.isNotEmpty) {
      _selfieLocalPath.value = initialImagePath;
      notifyListeners();
    }
    logger.d(
      "RRCAvatarProvider initialized with origin: $origin, initialImagePath: $initialImagePath, storyID: $storyID",
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

  Future<void> captureReactionImage() async {
    if (_isCapturingFace) return;
    _isCapturingFace = true;
    notifyListeners();

    camera.onFrame = (String? path) {
      logger.d("Trying to detect user expressions");
      if (path != null) {
        detectFace(path);
        notifyListeners();
      }
    };

    try {
      await camera.initialize();
    } catch (e) {
      logger.e('Failed to initialize camera: $e');
      _isCapturingFace = false;
      notifyListeners();
      AIHelpers.showToast(msg: 'Failed to start camera.');
    }
  }

  Future<void> detectFace(String link) async {
    // Use the hardcoded path from story_provider for consistency
    // link = '/data/data/insoblok.social.app/cache/me.jpg';

    logger.d("This is detect face function");
    try {
      var faces = await GoogleVisionHelper.getFacesFromImage(link: link);
      logger.d("These are faces $faces");
      logger.d("This is after google vision function");

      if (faces.isNotEmpty) {
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/face.png';
        final file = File(filePath);
        try {
          if (await file.exists()) {
            await file.delete();
          }
          final encoded = img.encodePng(faces[0]);
          await file.writeAsBytes(encoded, flush: true);

          // Verify file was created
          if (await file.exists()) {
            _capturedFacePath.value = filePath;
            // Also set as selfie if no selfie is set
            if (_selfieLocalPath.value == null ||
                _selfieLocalPath.value!.isEmpty) {
              _selfieLocalPath.value = filePath;
            }
            logger.d('✅ face.png saved at $filePath');
            logger.d('✅ capturedFacePath set to: ${_capturedFacePath.value}');
            logger.d('✅ selfieLocalPath set to: ${_selfieLocalPath.value}');
            // Notify listeners immediately after setting the value
            notifyListeners();
            AIHelpers.showToast(msg: 'Face captured successfully!');
          } else {
            throw Exception('File was not created at $filePath');
          }
        } catch (e) {
          logger.e('❌ Failed to write new face.png: $e');
          AIHelpers.showToast(msg: 'Failed to save face image');
        }
      } else {
        logger.e("No face detected!");
        AIHelpers.showToast(msg: 'No face detected!');
      }
    } catch (e) {
      logger.e('Error detecting face: $e');
      AIHelpers.showToast(msg: 'Failed to detect face');
    } finally {
      _isCapturingFace = false;
      await camera.stopAndDispose();
      notifyListeners();
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


    String? videoUrl;
    await runBusyFuture(() async {
      try {
        final prompt = emotions[selectedEmotionIndex]['prompt'] ?? 'laugh';

        // Ensure selfie uploaded once; avatar generation uses it as reference.
        String? imageUrl;
        await _ensureSelfieUploaded();
        imageUrl = _selfieCdnUrl.value;
        if (imageUrl == null || imageUrl.isEmpty) {
          throw Exception('Selfie URL is required. Please upload again.');
        }

        Map<String, dynamic> result;

        // If user picked "My Face" (index 0) -> direct video from selfie.
        // Else -> generate avatar then video based on selected avatar style.
        if (selectedAvatarIndex == 0) {
          logger.d(
            'Generating video with Cloudinary image: $imageUrl, prompt: $prompt',
          );
          result = await _runwareService.generateAIEmotionVideoWithPrompt(
            inputImage: imageUrl,
            positivePrompt: prompt,
          );
        } else {
          // Map selected avatar index to AvatarStyle
          late final AvatarStyle style;
          switch (selectedAvatarIndex) {
            case 1:
              style = AvatarStyle.seededit3d; // 3D via SeedEdit 3.0
              break;
            case 2:
              style = AvatarStyle.seedream3d; // 3D via Seedream 4.0
              break;
            case 3:
              style = AvatarStyle.seedreamAnime; // anime via Seedream 4.0
              break;
            case 4:
            default:
              style = AvatarStyle.seedreamNeonGlow; // neon glow via Seedream 4.0
          }

          logger.d(
            'Generating avatar ($style) then video. Prompt: $prompt',
          );
          result = await _runwareService.generateAvatarThenVideo(
            selfieImage: imageUrl,
            style: style,
            videoPrompt: prompt,
          );
        }

        if (result['status'] == 'success' && result['success'] == true) {
          final generatedVideoUrl = result['videoURL'] as String?;
          if (generatedVideoUrl != null && generatedVideoUrl.isNotEmpty) {
            _generatedVideoUrl.value = videoUrl = generatedVideoUrl;
            
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
      } catch (e, s) {
        setError(e);
        logger.e('Error generating video', error: e, stackTrace: s);

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
