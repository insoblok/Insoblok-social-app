import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;
import 'package:video_thumbnail/video_thumbnail.dart';

import 'package:flutter/material.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:image_picker/image_picker.dart';

class ReactionsProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  final controller = ScrollController();

  List<String> _reactions = [];
  List<String> get reactions => _reactions;

  // Store reactions with prompt information
  List<Map<String, dynamic>> _reactionsWithPrompt = [];
  List<Map<String, dynamic>> get reactionsWithPrompt => _reactionsWithPrompt;

  bool isCombineImages = false;
  bool isBusyPosting = false;

  late StoryModel _story;
  StoryModel get story => _story;
  set story(StoryModel model) {
    _story = model;
    notifyListeners();
  }

  bool _isStoryOwner = false;
  bool get isStoryOwner => _isStoryOwner;
  set isStoryOwner(bool f) {
    _isStoryOwner = f;
    notifyListeners();
  }

  /// Selected image URLs
  final List<String> _selectedImages = [];
  List<String> get selectedImages => _selectedImages;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> init(BuildContext context, {StoryModel? story}) async {
    this.context = context;
    logger.d("=== ReactionsProvider.init ===");
    logger.d("Story ID: ${story?.id}");
    logger.d("Story reactions from model: ${story?.reactions}");

    final auth = AuthHelper.user?.id;

    if (auth == story?.userId) {
      _isStoryOwner = true;
    }

    this.story = story!;

    // Initialize with reactions from story model if available
    if (story.reactions != null && story.reactions!.isNotEmpty) {
      // Clean URLs by removing any whitespace
      _reactions =
          story.reactions!
              .map((url) => url.trim().replaceAll(RegExp(r'\s+'), ''))
              .toList();
      logger.d("✅ Initialized reactions from story model: $_reactions");
      logger.d("✅ Reactions count: ${_reactions.length}");
      notifyListeners();
    } else {
      logger.w("⚠️ No reactions in story model");
    }

    // Fetch latest reactions from Firestore
    await fetchReactions(story.id!);

    logger.d("=== Final reactions: $_reactions ===");
    logger.d("=== Final reactions count: ${_reactions.length} ===");
  }

  Future<void> fetchReactions(String storyId) async {
    try {
      setBusy(true);

      logger.d("🔄 Fetching reactions from Firestore for story: $storyId");

      // Fetch reactions with prompt information
      final fetchedReactionsWithPrompt = await FirebaseHelper.service
          .fetchReactionsWithPrompt(storyId);
      logger.d(
        "📥 Fetched reactions with prompt from Firestore: $fetchedReactionsWithPrompt",
      );

      // Also fetch as URLs for backward compatibility
      final fetchedReactions = await FirebaseHelper.service.fetchReactions(
        storyId,
      );
      logger.d("📥 Fetched reactions from Firestore: $fetchedReactions");
      logger.d("📥 Fetched reactions count: ${fetchedReactions.length}");

      // Always use Firestore data if available, otherwise keep story model data
      if (fetchedReactions.isNotEmpty) {
        _reactions = fetchedReactions;
        _reactionsWithPrompt = fetchedReactionsWithPrompt;
        logger.d("✅ Updated reactions from Firestore: $_reactions");
        logger.d("✅ Updated reactions with prompt: $_reactionsWithPrompt");
      } else {
        // If Firestore returns empty but we had reactions from story model, keep them
        if (_reactions.isEmpty) {
          logger.w("⚠️ No reactions found in Firestore and story model");
          _reactions = [];
          _reactionsWithPrompt = [];
        } else {
          logger.d(
            "ℹ️ Firestore returned empty, keeping story model reactions: $_reactions",
          );
        }
      }
    } catch (e, stackTrace) {
      logger.e("❌ Error fetching reactions: $e");
      logger.e("Stack trace: $stackTrace");
      // Don't clear reactions if we had them from story model
      if (_reactions.isEmpty) {
        logger.w("⚠️ No reactions available after error");
        _reactions = [];
        _reactionsWithPrompt = [];
      } else {
        logger.d("ℹ️ Keeping existing reactions after error: $_reactions");
      }
    } finally {
      setBusy(false);
      notifyListeners();
      logger.d(
        "🔄 Fetch complete. Final reactions count: ${_reactions.length}",
      );
    }
  }

  /// Get prompt/type for a reaction URL
  String? getPromptForUrl(String url) {
    final reaction = _reactionsWithPrompt.firstWhere(
      (r) => r['url'] == url,
      orElse: () => <String, dynamic>{},
    );
    return reaction['prompt']?.toString() ?? reaction['type']?.toString();
  }

  /// Check if URL is a video
  bool _isVideo(String url) {
    final lowerUrl = url.toLowerCase();
    return lowerUrl.contains('.mp4') ||
        lowerUrl.contains('.mov') ||
        lowerUrl.contains('cloudinary.com/video/') ||
        lowerUrl.contains('video/upload');
  }

  /// Get count of selected videos
  int get selectedVideosCount {
    return _selectedImages.where((url) => _isVideo(url)).length;
  }

  /// Check if 1-3 videos are selected (valid selection)
  bool get hasValidVideoSelection {
    final count = selectedVideosCount;
    return count >= 1 && count <= 3;
  }

  /// Check if maximum videos (3) are selected
  bool get hasMaximumVideos => selectedVideosCount >= 3;

  /// Toggle image selection
  void toggleSelection(String imageUrl) {
    // Allow videos to be selected for playback control
    // The old check prevented videos from being selected, which prevented them from playing
    if (_selectedImages.contains(imageUrl)) {
      _selectedImages.remove(imageUrl);
    } else {
      // For videos, allow 1-3 selections
      // For images, allow up to 2 selections for combining
      final isVideo = _isVideo(imageUrl);

      if (isVideo) {
        // For videos, allow up to 3 selections
        if (selectedVideosCount < 3) {
          _selectedImages.add(imageUrl);
        }
      } else {
        // For images, allow up to 2 selections
        if (_selectedImages.length < 2) {
          _selectedImages.add(imageUrl);
        }
      }
    }
    notifyListeners();
  }

  bool isSelected(String imageUrl) {
    return _selectedImages.contains(imageUrl);
  }

  Future<void> postToLookBook() async {
    try {
      isBusyPosting = true;
      notifyListeners();

      // Check if 1-3 videos are selected
      final videoCount = selectedVideosCount;
      if (videoCount < 1 || videoCount > 3) {
        AIHelpers.showToast(
          msg: 'Please select 1 to 3 emotion videos to post to LookBook',
        );
        return;
      }

      // Get story media URL
      final storyMedia =
          (story.medias != null && story.medias!.isNotEmpty)
              ? story.medias![0]
              : null;
      if (storyMedia == null ||
          storyMedia.link == null ||
          storyMedia.link!.isEmpty) {
        AIHelpers.showToast(msg: 'No media in story');
        return;
      }

      // Get selected emotion video URLs
      final List<String> emotionVideoUrls = [];
      for (final url in _selectedImages) {
        if (_isVideo(url)) {
          emotionVideoUrls.add(url);
        }
      }

      if (emotionVideoUrls.isEmpty) {
        AIHelpers.showToast(msg: 'No emotion videos selected');
        return;
      }

      logger.d(
        'Posting story to LookBook with ${emotionVideoUrls.length} emotion videos',
      );
      logger.d('Emotion video URLs: $emotionVideoUrls');

      // Create and post story with emotion videos saved in reactions field
      // The story will be displayed with emotion videos around it in LookBook
      var newStory = StoryModel(
        title: 'Repost',
        text: story.text ?? '',
        status: 'private',
        category: 'vote',
        medias: story.medias, // Keep original story media
        reactions: emotionVideoUrls, // Save selected emotion videos
        updatedAt: DateTime.now(),
        createdAt: DateTime.now(),
        connects: [...(story.connects ?? [])],
      );

      logger.d('New story reactions before posting: ${newStory.reactions}');
      logger.d('New story reactions count: ${newStory.reactions?.length ?? 0}');

      final storyId = await storyService.postStory(story: newStory);
      logger.d('Story posted with ID: $storyId');

      // Verify the story was saved with reactions
      try {
        final savedStory = await storyService.getStory(storyId);
        logger.d('Saved story reactions: ${savedStory.reactions}');
        logger.d(
          'Saved story reactions count: ${savedStory.reactions?.length ?? 0}',
        );
      } catch (e) {
        logger.e('Error fetching saved story: $e');
      }

      await tastScoreService.repostScore(story);

      AIHelpers.showToast(msg: 'Successfully reposted to LOOKBOOK!');

      logger.d("Story posted with ${emotionVideoUrls.length} emotion videos");
    } catch (e, stackTrace) {
      logger.e("Error in postToLookBook: $e");
      logger.e("Stack trace: $stackTrace");
      AIHelpers.showToast(msg: 'Failed to post to LookBook: ${e.toString()}');
    } finally {
      isBusyPosting = false;
      notifyListeners();
    }
  }

  Future<Uint8List?> _composeImageWithOverlays({
    required String backgroundUrl,
    required List<String> overlayUrls,
  }) async {
    try {
      // Download background image bytes
      final bgBytes = await _downloadBytes(backgroundUrl);
      if (bgBytes == null) return null;

      // Decode to ui.Image
      final ui.Image bgImage = await _decodeImageFromList(bgBytes);

      final int bgWidth = bgImage.width;
      final int bgHeight = bgImage.height;

      // Determine overlay size (18% of width, clamped between 60 and 220)
      double overlaySize = bgWidth * 0.18;
      if (overlaySize < 60) overlaySize = 60;
      if (overlaySize > 220) overlaySize = 220;

      const double padding = 12.0;

      final recorder = ui.PictureRecorder();
      final canvas = Canvas(
        recorder,
        Rect.fromLTWH(0, 0, bgWidth.toDouble(), bgHeight.toDouble()),
      );
      final paint = Paint();

      // Draw background image full size
      canvas.drawImage(bgImage, Offset.zero, paint);

      // Use all provided overlays (1-3 videos)
      final overlaysToUse = overlayUrls;

      if (overlaysToUse.isEmpty) {
        // No overlays, just return background as PNG bytes
        final picture = recorder.endRecording();
        final ui.Image finalImage = await picture.toImage(bgWidth, bgHeight);
        final ByteData? png = await finalImage.toByteData(
          format: ui.ImageByteFormat.png,
        );
        return png?.buffer.asUint8List();
      }

      // Calculate total width needed by overlays plus padding between them
      double totalWidth =
          overlaysToUse.length * overlaySize +
          (overlaysToUse.length - 1) * padding;

      // Starting X to center overlays horizontally
      double startX = (bgWidth - totalWidth) / 2;

      // Y position to align overlays near bottom with padding
      double yPos = bgHeight - overlaySize - padding;

      // Draw each overlay image
      for (int i = 0; i < overlaysToUse.length; i++) {
        final url = overlaysToUse[i];

        // Download overlay bytes
        final overlayBytes = await _downloadBytes(url);
        if (overlayBytes == null) continue;

        // Decode overlay to ui.Image
        final ui.Image overlayImg = await _decodeImageFromList(overlayBytes);

        final srcRect = Rect.fromLTWH(
          0,
          0,
          overlayImg.width.toDouble(),
          overlayImg.height.toDouble(),
        );

        final dstRect = Rect.fromLTWH(
          startX + i * (overlaySize + padding),
          yPos,
          overlaySize,
          overlaySize,
        );

        // Clip overlay to circle
        canvas.save();
        final path = Path()..addOval(dstRect);
        canvas.clipPath(path);

        // Draw scaled overlay image
        canvas.drawImageRect(overlayImg, srcRect, dstRect, paint);
        canvas.restore();

        // Draw white circular border around overlay
        final borderPaint =
            Paint()
              ..style = PaintingStyle.stroke
              ..color = Colors.white
              ..strokeWidth =
                  overlaySize * 0.06; // border thickness proportional to size

        canvas.drawOval(dstRect, borderPaint);
      }

      // Finalize canvas to image
      final picture = recorder.endRecording();
      final ui.Image finalImage = await picture.toImage(bgWidth, bgHeight);

      // Convert to PNG bytes
      final ByteData? png = await finalImage.toByteData(
        format: ui.ImageByteFormat.png,
      );

      return png?.buffer.asUint8List();
    } catch (e, st) {
      logger.e('_composeImageWithOverlays error: $e\n$st');
      return null;
    }
  }

  Future<Uint8List?> _downloadBytes(String url) async {
    try {
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) return res.bodyBytes;
      logger.e('Failed to download $url status=${res.statusCode}');
      return null;
    } catch (e) {
      logger.e('Download error $e for $url');
      return null;
    }
  }

  // helper: decode bytes -> ui.Image (Completer wrapper for decodeImageFromList)
  Future<ui.Image> _decodeImageFromList(Uint8List bytes) {
    final completer = Completer<ui.Image>();
    ui.decodeImageFromList(bytes, (ui.Image img) {
      completer.complete(img);
    });
    return completer.future;
  }

  /// Compose videos: story in center, emotion videos around it
  Future<String?> _composeVideos({
    required String storyMediaUrl,
    required String storyMediaType,
    required List<String> emotionVideoUrls,
  }) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;

      // Download story media
      logger.d('Downloading story media: $storyMediaUrl');
      final storyMediaFile = File(
        '${tempDir.path}/story_$timestamp${storyMediaType == 'image' ? '.jpg' : '.mp4'}',
      );
      final storyBytes = await _downloadBytes(storyMediaUrl);
      if (storyBytes == null) {
        logger.e('Failed to download story media');
        return null;
      }
      await storyMediaFile.writeAsBytes(storyBytes);

      // Download emotion videos
      final List<File> emotionVideoFiles = [];
      for (int i = 0; i < emotionVideoUrls.length; i++) {
        logger.d('Downloading emotion video ${i + 1}: ${emotionVideoUrls[i]}');
        final emotionFile = File('${tempDir.path}/emotion_${i}_$timestamp.mp4');
        final emotionBytes = await _downloadBytes(emotionVideoUrls[i]);
        if (emotionBytes == null) {
          logger.e('Failed to download emotion video ${i + 1}');
          continue;
        }
        await emotionFile.writeAsBytes(emotionBytes);
        emotionVideoFiles.add(emotionFile);
      }

      if (emotionVideoFiles.isEmpty) {
        logger.e('No emotion videos downloaded');
        return null;
      }

      // Use image composition as fallback (create static image with video thumbnails)
      // This is a simpler approach that works without FFmpeg
      logger.d('Creating image composition from video thumbnails');

      // Generate thumbnails from videos
      final List<String> thumbnailUrls = [];

      // Get story thumbnail
      if (storyMediaType == 'image') {
        thumbnailUrls.add(storyMediaUrl);
      } else {
        final storyThumbnail = await _getVideoThumbnail(storyMediaUrl);
        if (storyThumbnail != null) {
          final thumbFile = File('${tempDir.path}/story_thumb_$timestamp.jpg');
          await thumbFile.writeAsBytes(storyThumbnail);
          final uploaded = await CloudinaryCDNService.uploadImageToCDN(
            XFile(thumbFile.path),
          );
          if (uploaded.link != null && uploaded.link!.isNotEmpty) {
            thumbnailUrls.add(uploaded.link!);
          } else {
            thumbnailUrls.add(storyMediaUrl); // Fallback to original URL
          }
        } else {
          thumbnailUrls.add(storyMediaUrl); // Fallback to original URL
        }
      }

      // Get emotion video thumbnails
      for (int i = 0; i < emotionVideoFiles.length; i++) {
        final thumbnail = await _getVideoThumbnail(emotionVideoUrls[i]);
        if (thumbnail != null) {
          final thumbFile = File(
            '${tempDir.path}/emotion_thumb_${i}_$timestamp.jpg',
          );
          await thumbFile.writeAsBytes(thumbnail);
          final uploaded = await CloudinaryCDNService.uploadImageToCDN(
            XFile(thumbFile.path),
          );
          if (uploaded.link != null && uploaded.link!.isNotEmpty) {
            thumbnailUrls.add(uploaded.link!);
          }
        }
      }

      if (thumbnailUrls.length < 2) {
        logger.e('Failed to generate enough thumbnails');
        return null;
      }

      // Create image composition
      final bgUrl = thumbnailUrls[0];
      final overlayUrls = thumbnailUrls.sublist(1);

      final pngBytes = await _composeImageWithOverlays(
        backgroundUrl: bgUrl,
        overlayUrls: overlayUrls,
      );

      if (pngBytes == null) {
        logger.e('Failed to create image composition');
        return null;
      }

      // Save composition as image (will be uploaded as image)
      final outputFile = File('${tempDir.path}/composed_$timestamp.png');
      await outputFile.writeAsBytes(pngBytes);

      logger.d('Image composition created: ${outputFile.path}');
      return outputFile.path;
    } catch (e, stackTrace) {
      logger.e('Error composing videos: $e');
      logger.e('Stack trace: $stackTrace');
      return null;
    }
  }

  // Generate thumbnail from video URL
  Future<Uint8List?> _getVideoThumbnail(String videoUrl) async {
    try {
      // Clean the URL first (remove whitespace, convert HTTP to HTTPS)
      String cleanUrl = videoUrl.trim().replaceAll(RegExp(r'\s+'), '');
      if (cleanUrl.startsWith('http://')) {
        cleanUrl = cleanUrl.replaceFirst('http://', 'https://');
      }

      // For Cloudinary videos, try to use the thumbnail URL if available
      if (cleanUrl.contains('cloudinary.com') && cleanUrl.contains('/video/')) {
        // Try to construct Cloudinary thumbnail URL
        // Format: https://res.cloudinary.com/{cloud_name}/video/upload/w_{width},h_{height},c_fill,so_2/{public_id}.jpg
        try {
          // Extract public_id from URL
          final uri = Uri.parse(cleanUrl);
          final pathSegments = uri.pathSegments;
          if (pathSegments.isNotEmpty) {
            final publicId = pathSegments.last
                .replaceAll('.mp4', '')
                .replaceAll('.mov', '');
            final cloudName = uri.host.split('.').first;
            final thumbnailUrl =
                'https://res.cloudinary.com/$cloudName/video/upload/w_200,h_200,c_fill,so_2/$publicId.jpg';

            // Try to download the thumbnail
            final thumbnailBytes = await _downloadBytes(thumbnailUrl);
            if (thumbnailBytes != null) {
              return thumbnailBytes;
            }
          }
        } catch (e) {
          logger.e('Failed to get Cloudinary thumbnail: $e');
        }
      }

      // Fallback: generate thumbnail using video_thumbnail package
      // Note: This requires downloading the video first, which can be slow
      // For network videos, we'll try to download a small portion first
      return await VideoThumbnail.thumbnailData(
        video: cleanUrl,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 200,
        quality: 75,
        timeMs: 1000, // Get frame at 1 second
      );
    } catch (e) {
      logger.e("Error generating video thumbnail: $e");
      return null;
    }
  }
}
