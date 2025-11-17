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
      final fetchedReactions = await FirebaseHelper.service.fetchReactions(
        storyId,
      );
      logger.d("📥 Fetched reactions from Firestore: $fetchedReactions");
      logger.d("📥 Fetched reactions count: ${fetchedReactions.length}");

      // Always use Firestore data if available, otherwise keep story model data
      if (fetchedReactions.isNotEmpty) {
        _reactions = fetchedReactions;
        logger.d("✅ Updated reactions from Firestore: $_reactions");
      } else {
        // If Firestore returns empty but we had reactions from story model, keep them
        if (_reactions.isEmpty) {
          logger.w("⚠️ No reactions found in Firestore and story model");
          _reactions = [];
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

  /// Toggle image selection
  void toggleSelection(String imageUrl) {
    // Allow videos to be selected for playback control
    // The old check prevented videos from being selected, which prevented them from playing
    if (_selectedImages.contains(imageUrl)) {
      _selectedImages.remove(imageUrl);
    } else {
      // For videos, allow single selection for playback
      // For images, allow up to 2 selections for combining
      final lowerUrl = imageUrl.toLowerCase();
      final isVideo =
          lowerUrl.contains('.mp4') ||
          lowerUrl.contains('.mov') ||
          lowerUrl.contains('cloudinary.com/video/') ||
          lowerUrl.contains('video/upload');

      if (isVideo) {
        // For videos, allow single selection (deselect others if needed)
        _selectedImages.clear();
        _selectedImages.add(imageUrl);
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

      // Check if any items are selected
      if (_selectedImages.isEmpty) {
        AIHelpers.showToast(msg: 'Please select at least one reaction to post to LookBook');
        return;
      }

      // Filter out videos and only use images, or generate thumbnails for videos
      final List<String> imageUrls = [];
      for (final url in _selectedImages) {
        final lowerUrl = url.toLowerCase();
        final isVideo = lowerUrl.contains('.mp4') ||
            lowerUrl.contains('.mov') ||
            lowerUrl.contains('cloudinary.com/video/') ||
            lowerUrl.contains('video/upload');

        if (isVideo) {
          // Generate thumbnail from video
          try {
            final thumbnailBytes = await _getVideoThumbnail(url);
            if (thumbnailBytes != null) {
              // Save thumbnail to temp file and upload to get URL
              final tempDir = await getTemporaryDirectory();
              final thumbnailFile = File(
                '${tempDir.path}/thumbnail_${DateTime.now().millisecondsSinceEpoch}.jpg',
              );
              await thumbnailFile.writeAsBytes(thumbnailBytes);
              
              // Upload thumbnail to Cloudinary to get URL
              final thumbnailModel = await CloudinaryCDNService.uploadImageToCDN(
                XFile(thumbnailFile.path),
              );
              if (thumbnailModel.link != null && thumbnailModel.link!.isNotEmpty) {
                imageUrls.add(thumbnailModel.link!);
              }
            }
          } catch (e) {
            logger.e('Failed to generate thumbnail for video $url: $e');
            // Skip this video if thumbnail generation fails
          }
        } else {
          // It's an image, use it directly
          imageUrls.add(url);
        }
      }

      if (imageUrls.isEmpty) {
        AIHelpers.showToast(msg: 'No valid images to post. Please select image reactions.');
        return;
      }

      isCombineImages = true;
      final bgUrl =
          (story.medias != null && story.medias!.isNotEmpty)
              ? (story.medias?[0].link)
              : '';
      if (bgUrl == null || bgUrl.isEmpty) {
        AIHelpers.showToast(msg: 'No background image in story');
        return;
      }

      final Uint8List? pngBytes = await _composeImageWithOverlays(
        backgroundUrl: bgUrl,
        overlayUrls: imageUrls.take(2).toList(), // up to 2 expected
      );

      if (pngBytes == null) {
        AIHelpers.showToast(msg: 'Failed to compose image');
        return;
      }

      var tempDir = await getTemporaryDirectory();

      var file = File(
        '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await file.writeAsBytes(pngBytes);
      MediaStoryModel model = await CloudinaryCDNService.uploadImageToCDN(
        XFile(file.path),
      );
      String? thumbUrl = model.link;
      if (thumbUrl == null || thumbUrl.isEmpty) {
        AIHelpers.showToast(msg: 'Failed to upload composed image');
        return;
      }

      isCombineImages = false;

      var newStory = StoryModel(
        title: 'Repost',
        text: story.text ?? '',
        status: 'private',
        category: 'vote',
        medias: [
          MediaStoryModel(
            link: thumbUrl,
            type: 'image',
            width: (story.medias ?? []).isNotEmpty
                ? (story.medias?[0].width ?? 0)
                : 0,
            height: (story.medias ?? []).isNotEmpty
                ? (story.medias?[0].height ?? 0)
                : 0,
          ),
        ],
        updatedAt: DateTime.now(),
        createdAt: DateTime.now(),
        connects: [...(story.connects ?? [])],
      );

      await storyService.postStory(story: newStory);
      await tastScoreService.repostScore(story);

      AIHelpers.showToast(msg: 'Successfully reposted to LOOKBOOK!');

      logger.d("thumbUrl: $thumbUrl");
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

      // Limit overlays to max 2
      final overlaysToUse = overlayUrls.take(2).toList();

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
            final publicId = pathSegments.last.replaceAll('.mp4', '').replaceAll('.mov', '');
            final cloudName = uri.host.split('.').first;
            final thumbnailUrl = 'https://res.cloudinary.com/$cloudName/video/upload/w_200,h_200,c_fill,so_2/$publicId.jpg';
            
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
