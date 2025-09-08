import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

import 'package:flutter/material.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

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
    logger.d("init function!");
    
    final auth = AuthHelper.user?.id;

    if(auth == story?.userId){
      _isStoryOwner = true;
    }
    
    this.story = story!;
    await fetchReactions(story.id!);
  }

  Future<void> fetchReactions(String storyId) async {
    try {
      setBusy(true);

      logger.d("reactions : $storyId");
      _reactions = await FirebaseHelper.service.fetchReactions(storyId);
      logger.d("reactions : $_reactions");

    } catch (e) {
      logger.e("Error fetching reactions: $e");
      _reactions = [];
    } finally {
      setBusy(false);
      notifyListeners();
    }
  }

  /// Toggle image selection
  void toggleSelection(String imageUrl) {

    final lowerUrl = imageUrl.toLowerCase();
    if (lowerUrl.contains('.mp4') || lowerUrl.contains('.mov')) {
      return;
    }

    if (_selectedImages.contains(imageUrl)) {
      _selectedImages.remove(imageUrl);
    } else {
      if (_selectedImages.length < 2) {
        _selectedImages.add(imageUrl);
      }
    }
    notifyListeners();
  }

  bool isSelected(String imageUrl) {
    return _selectedImages.contains(imageUrl);
  }

  Future<void> postToLookBook() async{

    try{
      isBusyPosting = true;
      notifyListeners();
      isCombineImages = true;
      final bgUrl = (story.medias != null && story.medias!.isNotEmpty)
            ? (story.medias?[0].link)
            : '';
        if (bgUrl == null) {
          logger.e('No background image in story');
          return;
        }
      final Uint8List? pngBytes = await _composeImageWithOverlays(
          backgroundUrl: bgUrl,
          overlayUrls: _selectedImages, // up to 2 expected
        );

      var tempDir = await getTemporaryDirectory();
      
      var file = File(
        '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await file.writeAsBytes(pngBytes!);
      MediaStoryModel model = await CloudinaryCDNService.uploadImageToCDN(XFile(file.path));
      String thumbUrl = model.link!;
      if(thumbUrl != null){
        isCombineImages = false;
      }
      
      var newStory = StoryModel(
      title: 'Repost',
      text: story.text!,
      status: 'private',
      category: 'vote',
      medias:
          (thumbUrl?.isNotEmpty ?? false)
              ? [
                MediaStoryModel(
                  link: thumbUrl,
                  type: 'image',
                  width: (story.medias ?? [])[0].width,
                  height: (story.medias ?? [])[0].height,
                ),
              ]
              : story.medias,
        updateDate: DateTime.now(),
        timestamp: DateTime.now(),
        connects: [
          ...(story.connects ?? []),
        ],
      );

      await storyService.postStory(story: newStory);
      await tastScoreService.repostScore(story);

      AIHelpers.showToast(msg: 'Successfully reposted to LOOKBOOK!');
      
      logger.d("thumbUrl: $thumbUrl");
    }catch(e){
      logger.e("Error in postToLookBook: $e");
    }finally{
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
        final ByteData? png = await finalImage.toByteData(format: ui.ImageByteFormat.png);
        return png?.buffer.asUint8List();
      }

      // Calculate total width needed by overlays plus padding between them
      double totalWidth = overlaysToUse.length * overlaySize +
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
        final borderPaint = Paint()
          ..style = PaintingStyle.stroke
          ..color = Colors.white
          ..strokeWidth = overlaySize * 0.06; // border thickness proportional to size

        canvas.drawOval(dstRect, borderPaint);
      }

      // Finalize canvas to image
      final picture = recorder.endRecording();
      final ui.Image finalImage = await picture.toImage(bgWidth, bgHeight);

      // Convert to PNG bytes
      final ByteData? png = await finalImage.toByteData(format: ui.ImageByteFormat.png);

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
}
