import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

import 'package:share_plus/share_plus.dart';

import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:insoblok/enums/enums.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/routers/router.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

enum AvatarProcessingMode { avatarGeneration, videoGeneration }

class RRCAvatarGenerationProvider extends InSoBlokViewModel {
  final ValueNotifier<String> currentVideoPath = ValueNotifier<String>('');

  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  final TIMER_LENGTH = 3;

  final avatarTemplates = [
    AIImages.avatarA,
    AIImages.avatarB,
    AIImages.avatarC,
    AIImages.avatarD,
  ];

  final prompts = [
    "",
    "Hyper Anime Eyes (exaggerated, glossy manga eyes with sparkle & emotion burst)",
    "Molten Liquid Chrome (reflective, morphing metallic skin, futuristic sheen)",
    "8-Bit Pixel Stormer (digital static, exploding pixel blocks, glitch storm)",
    "Neon Cyberpunk Rebel (glowing circuits, urban dystopia, holographic mask)",
    "Ultraviolet Neon Core (electric outlines, glowing edges, rave aesthetic)",
    "TasteScore Oracle (reputation mask, glowing meter, holographic score halo)",
    "Alt E-Core Icon (layered streetwear, dyed streak hair, glitch aura)",
    "Overloaded Drip Lord (bling, stickers, chaos, maximalist flex)",
    "Radiant Glow-Up Aura (ethereal lighting, soft gradients, sparkling",
    "Retro Grungewave Punk (90s grit + vaporwave neon overlays, cracked textures)",
    "anime",
  ];

  final List<String> avatarVideos = [
    "",
    "assets/videos/d0.mp4",
    "assets/videos/d3.mp4",
    "assets/videos/d18.mp4",
  ];

  String? media;

  int tappedImage = 0;
  bool isSelected = false;

  int count = 0;
  Timer? _timer;
  bool isProcessing = false;
  bool isCounting = false;
  File? face;

  int selectedAvatar = 0;
  int selectedVideo = 0;

  String? _cdnUploadId;
  String? get cdnUploadId => _cdnUploadId;
  set cdnUploadId(String? s) {
    _cdnUploadId = s;
    notifyListeners();
  }

  String? _storyID;
  String? get storyID => _storyID;
  set storyID(String? model) {
    _storyID = model;
    notifyListeners();
  }

  StoryModel? _story;
  StoryModel? get story => _story;
  set story(StoryModel? model) {
    _story = model;
    notifyListeners();
  }

  final Map<int, ValueNotifier<String>> avatarVideoNotifiers = {};

  late List<Uint8List> avatarResults = List.generate(
    avatarTemplates.length,
    (_) => Uint8List(0),
  );
  late List<String> videoResults = List.generate(
    avatarVideos.length,
    (_) => "",
  );

  bool isPosting = false;

  AvatarProcessingMode state = AvatarProcessingMode.avatarGeneration;

  late final tempDir;

  Future<void> init(
    String image,
    File face,
    String storyId,
    BuildContext ctx,
  ) async {
    this.storyID = storyId;
    media = image;
    this.face = face;
    avatarTemplates[0] = face.path;
    logger.d("face is ${face.path}");
    tempDir = await getTemporaryDirectory();
    if (videoResults.isNotEmpty && videoResults[1].isNotEmpty) {
      currentVideoPath.value = videoResults[1];
    }
    for (int i = 1; i < avatarVideos.length; i++) {
      avatarVideoNotifiers[i] = ValueNotifier<String>(avatarVideos[i]);
    }
    notifyListeners();
  }

  void setTappedImage(int index) {
    tappedImage = index;
    if (state == AvatarProcessingMode.videoGeneration &&
        index < videoResults.length &&
        videoResults[index].isNotEmpty) {
      currentVideoPath.value = videoResults[index];
    }
    notifyListeners();
  }

  void handleTapImage(int index, BuildContext ctx) {
    logger.d(
      "tapped $index, ${avatarResults[index].isNotEmpty}, $state, $isProcessing",
    );
    if (index < 0 || isProcessing) return;

    // First click on template: show origin face (for video) or generated avatar (for image)
    // Second click on same template: start generation process
    if (tappedImage == index) {
      if (state == AvatarProcessingMode.avatarGeneration) {
        selectedAvatar = index;
      } else if (state == AvatarProcessingMode.videoGeneration) {
        selectedVideo = index;
      }
      isSelected = true;
      _startTimer(ctx); // Start countdown, then generate
      notifyListeners();
      return;
    }

    // First click: just select the template and show preview (origin face for video)
    _stopTimer();
    setTappedImage(index);
    isSelected = false;
    notifyListeners();
  }

  Future<File?> downloadFile(Uint8List data, String fileName) async {
    if (Platform.isAndroid) {
      if (await Permission.videos.isDenied ||
          await Permission.videos.isRestricted) {
        await Permission.videos.request();
      }

      // For older Androids
      if (await Permission.storage.isDenied) {
        await Permission.storage.request();
      }

      // If all denied, abort
      if (await Permission.videos.isDenied &&
          await Permission.storage.isDenied) {
        logger.d('❌ Permission denied');
        return null;
      }
    }
    Directory? downloadsDir;
    if (Platform.isAndroid) {
      downloadsDir = Directory('/storage/emulated/0/Download');
    } else {
      downloadsDir = await getDownloadsDirectory(); // Works on desktop/macOS
    }
    if (!await downloadsDir!.exists()) {
      await downloadsDir.create(recursive: true);
    }

    // Create file and write bytes
    final file = File('${downloadsDir.path}/$fileName');
    await file.writeAsBytes(data);
    // AIHelpers.showToast(msg: "Download complete");
    return file;
  }

  void _startTimer(BuildContext ctx) {
    if (isCounting) return; // avoid multiple timers
    isCounting = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      count++;
      if (count > TIMER_LENGTH) {
        _stopTimer();
        isProcessing = true;
        notifyListeners();
        final generated = await requestProcess();
        if (generated.isEmpty) {
          AIHelpers.showToast(
            msg: "Failed to generate results. Please try again.",
          );
          isProcessing = false;
          return;
        }
        if (state == AvatarProcessingMode.avatarGeneration) {
          avatarResults[tappedImage] = generated;
        } else {
          final name = '${tempDir.path}/video_$tappedImage.mp4';
          final video = File(name);

          // Ensure the file doesn't exist before writing
          if (await video.exists()) {
            await video.delete();
          }

          // Write the video data
          await video.writeAsBytes(generated, flush: true);

          // Validate the file was written correctly
          if (await video.exists() && await video.length() > 0) {
            // Wait a bit more to ensure file is fully written
            await Future.delayed(const Duration(milliseconds: 500));

            // Update the results
            final valid = await validateFile(video.path);
            // if (valid) videoResults[tappedImage] = video.path;
            if (valid)
              videoResults[tappedImage] =
                  "data/user/0/insoblok.social.app/cache/video_1.mp4";
            currentVideoPath.value = video.path;
          } else {
            logger.e("Failed to write video file or file is empty");
          }
        }
        isProcessing = false;
      }
      notifyListeners();
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    isCounting = false;
    count = 0;
  }

  @override
  void dispose() {
    _timer?.cancel();
    currentVideoPath.dispose();
    super.dispose();
    for (final notifier in avatarVideoNotifiers.values) {
      notifier.dispose();
    }
  }

  // function to make post request to avatar server to generate a avatar or avatar videos
  Future<Uint8List> requestProcess() async {
    Uint8List result;
    String path = face?.path ?? "";

    // Validate that origin face file exists
    if (path.isEmpty || face == null) {
      logger.e("Origin face file is missing for video generation");
      return Uint8List(0);
    }

    // Always use the ORIGIN face image (never generated avatars)
    final originFaceImageBase64 = await AIHelpers.image2Base64(
      path,
      SourceType.file,
    );
    var body;
    try {
      if (state == AvatarProcessingMode.avatarGeneration) {
        if (selectedAvatar == 0) {
          return await File(path).readAsBytes();
          // ignore: curly_braces_in_flow_control_structures
        } else if (selectedAvatar == 10)
          return await requestToGetIMGAI(path, prompts[10]);
        body = jsonEncode({
          "prompt": prompts[selectedAvatar],
          "image": originFaceImageBase64,
        });
        logger.d("avatar generation request body is $body");
      } else {
        // VIDEO GENERATION: ONLY use origin face image, NEVER use generated avatars
        final video = await AIHelpers.image2Base64(
          avatarVideos[selectedVideo],
          SourceType.assets,
        );
        // Explicitly use origin face image base64 (NOT avatarResults)
        final originFaceForVideo = originFaceImageBase64;
        logger.d(
          "Video generation - Using ORIGIN face image only (NOT generated avatar)",
        );
        logger.d("Origin face path: $path");
        logger.d(
          "Video base64 length: ${video.length}, Origin face base64 length: ${originFaceForVideo.length}",
        );
        body = jsonEncode({
          "image": originFaceForVideo,
          "video": video,
          "fps": 25,
        });
        logger.d(
          "Video generation request body prepared with origin face image",
        );
      }
      // 4️⃣ Send POST request
      final url =
          "${state == AvatarProcessingMode.avatarGeneration ? AVATAR_GENERATION_SERVER_ENDPOINT : AVATAR_VIDEO_GENERATION_SERVER_ENDPOINT}/generate";
      logger.d("Url is $url");
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: body,
      );
      // 5️⃣ Handle response
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        logger.d("This is response body ${data}");
        result = await AIHelpers.base642Image(data["output"]);
      } else {
        logger.d("❌ Error: ${response.statusCode} - ${response.body}");
        result = Uint8List(0);
      }
    } catch (e) {
      logger.e(e);
      result = Uint8List(0);
    }
    isSelected = false;
    return result;
  }

  // generate avatar image by using getimg.ai APIs' legacy api
  Future<Uint8List> requestToGetIMGAI(String path, String prompt) async {
    Uint8List result = Uint8List(0);
    final base64FaceImage = await AIHelpers.image2Base64(path, SourceType.file);
    final body = jsonEncode({
      "model": "stable-diffusion-v1-5",
      "prompt": prompt,
      "image": base64FaceImage,
      "output_format": "jpeg",
      "response_format": "b64",
    });
    final headers = {
      "accept": "application/json",
      "content-type": "application/json",
      "Authentication": "Bearer ${GET_IMG_AI_API_KEY}",
    };
    try {
      final response = await http.post(
        Uri.parse(GET_IMG_AI_ENDPOINT),
        headers: headers,
        body: body,
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        logger.d("This is response body ${data}");
        result = await AIHelpers.base642Image(data["image"]);
      }
    } catch (e) {
      logger.d("An exception raised while making request to getimg.ai $e");
    }
    return result;
  }

  // toggle post mode (show/hide "Add emotions", "Post", "Save to gallery", "Cancel" buttons at the bottom of the RRC Avatar Generation Screen)
  void togglePost() {
    logger.d(
      "Avatar Results is $selectedAvatar, ${avatarResults[selectedAvatar]}",
    );
    isPosting = !isPosting;
    notifyListeners();
  }

  // handler function to process the tap event on "Add Emotions" button at the bottom of Avatar Generation Screen
  void handleTapAddEmotions() {
    if (tappedImage > 1 && tappedImage < 6) return;
    logger.d("$isSelected, $selectedAvatar, ${avatarResults[selectedAvatar]}");
    if (avatarResults[selectedAvatar].isEmpty) {
      AIHelpers.showToast(
        msg: "Need to generate an avatar first to add emotions",
      );
      return;
    }
    if (state == AvatarProcessingMode.avatarGeneration) {
      state = AvatarProcessingMode.videoGeneration;
    } else {
      state = AvatarProcessingMode.avatarGeneration;
    }
    isSelected = false;
    tappedImage = 0;
    notifyListeners();
  }

  /// Validates if a video file exists and is readable
  Future<bool> validateFile(String path) async {
    if (path.isEmpty) return false;
    if (path.contains("assets")) return true;
    try {
      final file = File(path);
      if (!await file.exists()) {
        logger.d("Video file does not exist: $path");
        return false;
      }

      final fileSize = await file.length();
      if (fileSize == 0) {
        logger.d("Video file is empty: $path");
        return false;
      }

      logger.d("Video file validation passed: $path, size: $fileSize");
      return true;
    } catch (e) {
      logger.e("Error validating video file $path: $e");
      return false;
    }
  }

  bool checkIfProcessed() {
    bool allAvatarsEmpty = avatarResults.every((data) => data.isEmpty);
    bool allVideosEmpty = videoResults.every((path) => path.isEmpty);
    if (allAvatarsEmpty && allVideosEmpty) {
      AIHelpers.showToast(
        msg: "No generated results. Please generate one first.",
      );
      return false;
    }
    if ((state == AvatarProcessingMode.avatarGeneration &&
            avatarResults[tappedImage].isEmpty) ||
        (state == AvatarProcessingMode.videoGeneration &&
            videoResults[tappedImage].isEmpty)) {
      AIHelpers.showToast(
        msg: "No generated results. Please select a generated result.",
      );
      return false;
    }
    return true;
  }

  // handler to process tap event on save button on Appbar of RRC Avatar Generation Screen
  Future<void> handleTapSave(BuildContext ctx) async {
    if (state == AvatarProcessingMode.avatarGeneration) {
      File? result = await saveBytesToTemporaryDirectory(
        avatarResults[selectedAvatar],
        "avatar.jpg",
      );
      if (result == null) {
        AIHelpers.showToast(
          msg: "Failed to save generated avatar image on temporary directory.",
        );
        return;
      }
      Routers.goToAccountAvatarPage(ctx, face?.path, result.path);
    } else {
      Routers.goToAccountAvatarPage(
        ctx,
        face?.path,
        videoResults[selectedVideo],
      );
    }
  }

  // save Uint8List data into fileSystem's temporary directory like data/user/0/insoblok.social.app/cache/*.*
  Future<File?> saveBytesToTemporaryDirectory(
    Uint8List data,
    String fileName,
  ) async {
    try {
      String path = "${tempDir.path}/$fileName";
      final result = File(path);
      await result.writeAsBytes(data);
      bool valid = await validateFile(path);
      if (valid) {
        return result;
      } else {
        return null;
      }
    } catch (e) {
      logger.e(
        "Exception raised while saving file to temporary directory: $fileName : $e",
      );
      return null;
    }
  }

  // post the result avatar image or video to gallery when user taps on "Save to Gallery" button on the bottom
  Future<void> saveToGallery() async {
    if (isBusy) return;
    clearErrors();

    // Check if user is authenticated
    final userId = AuthHelper.user?.id;
    if (userId == null || userId.isEmpty) {
      AIHelpers.showToast(msg: "Please log in to save to gallery");
      return;
    }

    setBusy(true);
    notifyListeners();
    String link = "";
    MediaStoryModel? model;
    try {
      if (cdnUploadId == null) {
        if (state == AvatarProcessingMode.avatarGeneration) {
          if (avatarResults[tappedImage] == Uint8List(0)) {
            AIHelpers.showToast(
              msg: "Need to generate an avatar first to save to gallery",
            );
            setBusy(false);
            notifyListeners();
            return;
          }
          File? result = await downloadFile(
            avatarResults[tappedImage],
            "reaction.jpg",
          );
          if (result == null) {
            AIHelpers.showToast(msg: "Failed to save file locally");
            setBusy(false);
            notifyListeners();
            return;
          }
          model = await CloudinaryCDNService.uploadImageToCDN(
            XFile(result.path),
          );
        } else {
          if (videoResults[tappedImage].isEmpty) {
            AIHelpers.showToast(
              msg: "Need to generate a video first to save to gallery",
            );
            setBusy(false);
            notifyListeners();
            return;
          }
          model = await CloudinaryCDNService.uploadVideoToCDN(
            XFile(videoResults[tappedImage]),
          );
        }
        if (model.link == null || model.link!.isEmpty) {
          AIHelpers.showToast(
            msg: "Failed to upload to CDN. Please try again.",
          );
          setBusy(false);
          notifyListeners();
          return;
        }
        cdnUploadId = model.publicId;
        link = model.link!;
      } else {
        // If cdnUploadId exists but link is empty, we need to reconstruct or re-upload
        // For now, re-upload to get the link
        if (link.isEmpty) {
          if (state == AvatarProcessingMode.avatarGeneration) {
            if (avatarResults[tappedImage] == Uint8List(0)) {
              AIHelpers.showToast(
                msg: "Need to generate an avatar first to save to gallery",
              );
              setBusy(false);
              notifyListeners();
              return;
            }
            File? result = await downloadFile(
              avatarResults[tappedImage],
              "reaction.jpg",
            );
            if (result == null) {
              AIHelpers.showToast(msg: "Failed to save file locally");
              setBusy(false);
              notifyListeners();
              return;
            }
            model = await CloudinaryCDNService.uploadImageToCDN(
              XFile(result.path),
            );
          } else {
            if (videoResults[tappedImage].isEmpty) {
              AIHelpers.showToast(
                msg: "Need to generate a video first to save to gallery",
              );
              setBusy(false);
              notifyListeners();
              return;
            }
            model = await CloudinaryCDNService.uploadVideoToCDN(
              XFile(videoResults[tappedImage]),
            );
          }
          if (model.link == null || model.link!.isEmpty) {
            AIHelpers.showToast(
              msg: "Failed to upload to CDN. Please try again.",
            );
            setBusy(false);
            notifyListeners();
            return;
          }
          link = model.link!;
        }
      }

      // Validate link before proceeding
      if (link.isEmpty) {
        AIHelpers.showToast(msg: "Failed to get media link. Please try again.");
        setBusy(false);
        notifyListeners();
        return;
      }

      final usersRef = FirebaseFirestore.instance.collection("users2");
      // Save gallery as an object with proper structure, not just a string
      // fetchGalleries expects galleries to be List<Map> with status: "active"
      // Use ISO8601 string format for timestamps (not FieldValue.serverTimestamp() which doesn't work in arrays)
      final now = DateTime.now().toUtc().toIso8601String();
      final galleryData = {
        "media": link,
        "status": "active",
        "created_at": now,
        "updated_at": now,
      };

      logger.d('=== Saving Gallery ===');
      logger.d('User ID: ${AuthHelper.user?.id}');
      logger.d('Gallery Data: $galleryData');

      // Get current galleries, add the new one, and update
      final userDoc = await usersRef.doc(userId).get();
      List<Map<String, dynamic>> currentGalleries = [];

      if (userDoc.exists) {
        final userData = userDoc.data();
        if (userData != null && userData['galleries'] != null) {
          final galleriesList = userData['galleries'] as List;
          logger.d('Current galleries count: ${galleriesList.length}');

          // Handle mixed format: some might be strings (old format), some objects (new format)
          currentGalleries =
              galleriesList.map((item) {
                if (item is String) {
                  // Convert old string format to new object format
                  return {
                    "media": item,
                    "status": "active",
                    "created_at": now, // Use current time for migrated items
                    "updated_at": now,
                  };
                } else if (item is Map) {
                  // Already in object format, ensure it's properly typed
                  return Map<String, dynamic>.from(item);
                }
                // Fallback: convert to proper format
                return {
                  "media": item.toString(),
                  "status": "active",
                  "created_at": now,
                  "updated_at": now,
                };
              }).toList();
        }
      }

      // Add new gallery to the list
      currentGalleries.add(Map<String, dynamic>.from(galleryData));
      logger.d('Total galleries after adding: ${currentGalleries.length}');

      // Update with the complete list
      // Use set with merge: true if document doesn't exist, otherwise update
      if (!userDoc.exists) {
        await usersRef.doc(userId).set({
          "galleries": currentGalleries,
        }, SetOptions(merge: true));
      } else {
        await usersRef.doc(userId).update({"galleries": currentGalleries});
      }

      logger.d('Gallery saved successfully to Firestore');
      logger.d('Gallery link: $link');
      logger.d('========================');
      AIHelpers.showToast(msg: 'Successfully saved to Gallery!');
    } catch (e, stackTrace) {
      setError(e);
      logger.e('Error saving to gallery: $e');
      logger.e(stackTrace);
      // Show user-friendly error message
      String errorMessage = "Failed to save to gallery. Please try again.";
      if (e.toString().contains("permission") ||
          e.toString().contains("Permission")) {
        errorMessage = "Permission denied. Please check app permissions.";
      } else if (e.toString().contains("network") ||
          e.toString().contains("Network")) {
        errorMessage =
            "Network error. Please check your connection and try again.";
      } else if (e.toString().contains("firebase") ||
          e.toString().contains("Firebase")) {
        errorMessage = "Database error. Please try again later.";
      }
      AIHelpers.showToast(msg: errorMessage);
    } finally {
      setBusy(false);
      notifyListeners();
    }
  }

  //
  Future<void> postAsReaction() async {
    if (isBusy) return;
    clearErrors();

    // Check if user is trying to react to their own story
    if (storyID != null && storyID!.isNotEmpty) {
      try {
        final story = await storyService.getStory(storyID!);
        if (story.userId == AuthHelper.user?.id) {
          AIHelpers.showToast(msg: "You can't react on your post!");
          return;
        }
      } catch (e) {
        logger.e('Error fetching story: $e');
        // Continue anyway - better to allow reaction than block due to fetch error
      }
    }

    setBusy(true);
    notifyListeners();

    String url = "";
    try {
      if (cdnUploadId == null) {
        MediaStoryModel model = await CloudinaryCDNService.uploadImageToCDN(
          XFile(face!.path),
        );
        cdnUploadId = model.publicId;
        url = model.link!;
      }

      final storiesRef = FirebaseFirestore.instance.collection("story");
      await storiesRef.doc(storyID).update({
        "reactions": FieldValue.arrayUnion([url]),
      });

      AIHelpers.showToast(msg: 'Successfully posted as Reaction!');
    } catch (e) {
      setError(e);
      logger.e(e);
    } finally {
      setBusy(false);
      notifyListeners();
    }
  }
}
