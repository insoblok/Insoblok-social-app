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
          String? imageToUseForVideo = imageUrl;

          // If avatar style is selected, first generate the avatar image
          if (selectedAvatarIndex > 0 && selectedAvatarIndex < avatars.length) {
            logger.d(
              'Avatar style selected (index: $selectedAvatarIndex). Generating avatar first...',
            );

            final avatarPrompt =
                avatars[selectedAvatarIndex]['prompt'] ??
                'high quality portrait';

            logger.d(
              'Generating avatar with user face: $imageUrl, prompt: $avatarPrompt',
            );

            // Step 1: Generate AI avatar from user face
            final avatarResult = await _runwareService
                .generateAIAvatarWithPromptOption1(
                  inputImage: imageUrl,
                  positivePrompt: avatarPrompt,
                );

            if (avatarResult['status'] == 'success' &&
                avatarResult['success'] == true) {
              final generatedAvatarUrl = avatarResult['imageURL'] as String?;
              if (generatedAvatarUrl != null && generatedAvatarUrl.isNotEmpty) {
                // Store the generated avatar image URL
                _generatedAvatarImageUrl.value = generatedAvatarUrl;
                // Use the generated avatar image for video generation
                imageToUseForVideo = generatedAvatarUrl;
                logger.d(
                  '✅ Avatar generated successfully: $generatedAvatarUrl',
                );
                logger.d('✅ Using avatar image for emotion video generation');
                notifyListeners();
                AIHelpers.showToast(msg: 'Avatar generated! Creating video...');
              } else {
                throw Exception('Avatar image URL not found in response');
              }
            } else if (avatarResult['status'] == 'processing') {
              logger.w(
                'Avatar is still processing. Task UUID: ${avatarResult['taskUUID']}',
              );
              throw Exception(
                'Avatar generation is still processing. Please wait and try again.',
              );
            } else {
              final errorMsg =
                  avatarResult['message'] ?? 'Unknown error occurred';
              logger.e('Avatar generation failed: $errorMsg');
              throw Exception('Avatar generation failed: $errorMsg');
            }
          }

          // Step 2: Generate emotion video (using avatar image if avatar was selected, otherwise original face)
          final prompt = emotions[selectedEmotionIndex]['prompt'] ?? 'laugh';
          logger.d(
            'Generating emotion video with image: $imageToUseForVideo, prompt: $prompt',
          );

          final result = await _runwareService.generateAIEmotionVideoWithPrompt(
            inputImage: imageToUseForVideo,
            positivePrompt: prompt,
          );

          if (result['status'] == 'success' && result['success'] == true) {
            final generatedVideoUrl = result['videoURL'] as String?;
            if (generatedVideoUrl != null && generatedVideoUrl.isNotEmpty) {
              // Validate URL format
              if (!generatedVideoUrl.startsWith('http://') &&
                  !generatedVideoUrl.startsWith('https://')) {
                throw Exception('Invalid video URL format: $generatedVideoUrl');
              }

              // Skip URL validation to save time - video player will handle invalid URLs
              // URL validation is async and adds unnecessary delay
              logger.d('✅ Video URL received: $generatedVideoUrl');

              _generatedVideoUrl.value = resultUrl = generatedVideoUrl;
              logger.d('✅ Video URL set: ${_generatedVideoUrl.value}');
              logger.d('✅ Generated video URL: $generatedVideoUrl');
              // Notify listeners immediately to update UI
              notifyListeners();
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

  Future<void> postAsReaction() async {
    if (isBusy) return;

    final generatedVideoUrl = _generatedVideoUrl.value;
    logger.d(
      'postAsReaction called - Video URL: $generatedVideoUrl, Story ID: $_storyID',
    );

    if (generatedVideoUrl == null || generatedVideoUrl.isEmpty) {
      logger.e('No video generated yet');
      AIHelpers.showToast(
        msg: 'No video generated yet. Please generate a video first.',
      );
      return;
    }
    if (_storyID == null || _storyID!.isEmpty) {
      logger.e('Story ID is missing');
      AIHelpers.showToast(msg: 'Story ID is missing. Cannot post reaction.');
      return;
    }

    // Check if user is trying to react to their own story
    try {
      final story = await storyService.getStory(_storyID!);
      logger.d(
        'Fetched story - Story ID: ${story.id}, Story userId: ${story.userId}, Current user ID: ${AuthHelper.user?.id}',
      );

      if (story.userId != null &&
          AuthHelper.user?.id != null &&
          story.userId == AuthHelper.user?.id) {
        logger.e('User trying to react to their own story - Blocking reaction');
        AIHelpers.showToast(msg: "You can't react to your own story!");
        return;
      }
      logger.d('Story ownership check passed - User can react');
    } catch (e, stackTrace) {
      logger.e('Error fetching story for validation: $e');
      logger.e('Stack trace: $stackTrace');
      // Continue anyway - better to allow reaction than block due to fetch error
      logger.w('Allowing reaction despite validation error');
    }

    clearErrors();
    setBusy(true);
    notifyListeners();

    try {
      String videoUrl = generatedVideoUrl;
      File? videoFile;

      // If video URL is a network URL, download it first
      if (videoUrl.startsWith('http://') || videoUrl.startsWith('https://')) {
        logger.d('Downloading video from URL: $videoUrl');

        final tempDir = await getTemporaryDirectory();
        final fileExtension = p.extension(videoUrl);
        final extension = fileExtension.isEmpty ? '.mp4' : fileExtension;
        final fullPath =
            '${tempDir.path}/${AuthHelper.user?.id}_reaction_${DateTime.now().millisecondsSinceEpoch}$extension';

        try {
          final dio = Dio();
          final response = await dio.get(
            videoUrl,
            options: Options(
              responseType: ResponseType.bytes,
              followRedirects: true,
              validateStatus: (status) => (status ?? 600) < 500,
            ),
          );

          if (response.statusCode != 200) {
            throw Exception(
              'Failed to download video: HTTP ${response.statusCode}',
            );
          }

          if (response.data == null || (response.data as List<int>).isEmpty) {
            throw Exception('Downloaded video data is empty');
          }

          videoFile = File(fullPath);
          final raf = videoFile.openSync(mode: FileMode.write);
          raf.writeFromSync(response.data);
          await raf.close();

          logger.d('Video downloaded successfully to: ${videoFile.path}');
        } catch (e) {
          logger.e('Error downloading video: $e');
          throw Exception('Failed to download video from URL: $e');
        }
      } else {
        // It's a local file path
        videoFile = File(videoUrl);
        if (!await videoFile.exists()) {
          throw Exception('Video file not found: $videoUrl');
        }
        logger.d('Using local video file: ${videoFile.path}');
      }

      // Verify video file exists and is readable
      if (!await videoFile.exists()) {
        throw Exception('Video file does not exist: ${videoFile.path}');
      }

      final fileSize = await videoFile.length();
      logger.d('Video file size: $fileSize bytes');

      if (fileSize == 0) {
        throw Exception('Video file is empty: ${videoFile.path}');
      }

      // Upload video to Cloudinary CDN
      logger.d('Uploading video to Cloudinary: ${videoFile.path}');
      final model = await CloudinaryCDNService.uploadVideoToCDN(
        XFile(videoFile.path),
      );

      final cdnUrl = model.link;
      if (cdnUrl == null || cdnUrl.isEmpty) {
        throw Exception(
          'Failed to upload video to Cloudinary: No URL returned',
        );
      }

      logger.d('Video uploaded to Cloudinary successfully: $cdnUrl');

      // Update Firestore story document with reaction
      final storiesRef = FirebaseFirestore.instance.collection("story");
      await storiesRef.doc(_storyID).update({
        "reactions": FieldValue.arrayUnion([cdnUrl]),
      });

      logger.d('Reaction posted successfully to story: $_storyID');
      AIHelpers.showToast(msg: 'Successfully posted as Reaction!');

      // Trigger story update notification to refresh main page
      try {
        await storyService.updateStoryUpdated();
        logger.d('Story update notification triggered');
      } catch (e) {
        logger.e('Failed to trigger story update: $e');
      }

      // Navigate to main page and clear navigation stack
      if (context.mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          kRouterMain,
          (Route<dynamic> route) => false, // Remove all previous routes
        );
      }
    } catch (e, stackTrace) {
      setError(e);
      logger.e('Error posting reaction: $e');
      logger.e(stackTrace);
      AIHelpers.showToast(msg: 'Failed to post reaction: ${e.toString()}');
    } finally {
      setBusy(false);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    camera.dispose();
    super.dispose();
  }
}
