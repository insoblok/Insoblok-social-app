// media_picker_service.dart
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';

import 'package:insoblok/pages/vtos/deep_ar_plus_page.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/models/models.dart';

// Feature flag: show/hide DeepAR option in the media source sheet.
const bool kShowDeepARButton = false;


enum PickerAction { gallery, camera, deepAr }

class MediaPickerService with ListenableServiceMixin {
  MediaPickerService();

  // Keep the picker as a field, NOT a BuildContext.
  final ImagePicker _picker = ImagePicker();

  String _editedImagePath = "";
  String get editedImagePath => _editedImagePath;
  set editedImagePath(String s) {
    _editedImagePath = s;
    notifyListeners();
  }

  StoryModel? currentStory;

  /// Pick 1..N story medias. Opens a source sheet (Photos / Camera / DeepAR).
  Future<List<XFile>> onPickerStoryMedia(
    BuildContext context, {
    int? limit,
  }) async {
    try {
      final action = await _showMediaSource(context);
      logger.d('mediaSource = $action');

      if (action == null) return <XFile>[];

      // DeepAR
      if (action == PickerAction.deepAr) {
        // Ensure camera permission before opening DeepAR
        final allow = await PermissionService.requestCameraPermission();
        if (allow != true) {
          AIHelpers.showToast(msg: 'Camera permission is required');
          return <XFile>[];
        }
        final result = await Navigator.of(context).push<Map<String, String?>>(
          MaterialPageRoute(builder: (_) => const DeepARPlusPage()),
        );

        final medias = <XFile>[];
        if (result != null) {
          final photoPath = result['photo'];
          final videoPath = result['video'];
          if (photoPath?.isNotEmpty == true) medias.add(XFile(photoPath!));
          if (videoPath?.isNotEmpty == true) medias.add(XFile(videoPath!));
        }

        if (medias.isEmpty) {
          AIHelpers.showToast(msg: 'No media captured!');
        }
        logger.d('DeepAR medias: $medias');
        return medias;
      }

      // Gallery/Camera permissions
      final isAllowed = action == PickerAction.gallery
          ? ((await PermissionService.requestGalleryPermission()) ?? false)
          : ((await PermissionService.requestCameraPermission()) ?? false);

      if (!isAllowed) {
        AIHelpers.showToast(msg: 'Permission denied!');
        return <XFile>[];
      }

      final medias = <XFile>[];

      if (action == PickerAction.camera) {
        // Use your platform camera (may return content:// on Android)
        final mediaPath = await MethodChannelService.onPlatformCameraPicker();
        if (mediaPath != null && mediaPath.isNotEmpty) {
          logger.d('camera path: $mediaPath');
          medias.add(XFile(mediaPath));
        }
      } else {
        // Gallery multi-picker (images + videos)
        final selects = await onMultiMediaPicker(limit: limit);
        medias.addAll(selects);
      }

      if (medias.isEmpty) {
        AIHelpers.showToast(msg: 'No selected medias!');
      }
      return medias;
    } catch (e, st) {
      logger.e('onPickerStoryMedia error', error: e, stackTrace: st);
      AIHelpers.showToast(msg: 'Couldn’t pick media. Please try again.');
      return <XFile>[];
    }
  }

  /// Pick a single image or video. Uses the same source sheet.
  Future<XFile?> onPickerSingleMedia(
    BuildContext context, {
    required bool isImage,
    Duration? maxDuration,
  }) async {
    try {
      final action = await _showMediaSource(context);
      logger.d('single media source = $action');
      if (action == null) return null;

      if (action == PickerAction.deepAr) {
        // Ensure camera permission before opening DeepAR
        final allow = await PermissionService.requestCameraPermission();
        if (allow != true) {
          AIHelpers.showToast(msg: 'Camera permission is required');
          return null;
        }
        final result = await Navigator.of(context).push<Map<String, String?>>(
          MaterialPageRoute(builder: (_) => const DeepARPlusPage()),
        );
        if (result != null) {
          final p = isImage ? result['photo'] : result['video'];
          if (p != null && p.isNotEmpty) return XFile(p);
        }
        AIHelpers.showToast(msg: 'No ${isImage ? 'image' : 'video'} captured!');
        return null;
      }

      final isAllowed = action == PickerAction.gallery
          ? ((await PermissionService.requestGalleryPermission()) ?? false)
          : ((await PermissionService.requestCameraPermission()) ?? false);

      if (!isAllowed) {
        AIHelpers.showToast(msg: 'Permission denied!');
        return null;
      }

      XFile? media;
      if (isImage) {
        media = action == PickerAction.gallery
            ? await _picker.pickImage(source: ImageSource.gallery)
            : await _picker.pickImage(source: ImageSource.camera);
      } else {
        media = await _picker.pickVideo(
          source: action == PickerAction.gallery ? ImageSource.gallery : ImageSource.camera,
          maxDuration: maxDuration,
        );
      }

      if (media == null) {
        AIHelpers.showToast(msg: 'No selected ${isImage ? 'image' : 'video'}!');
      }
      return media;
    } catch (e, st) {
      logger.e('onPickerSingleMedia error', error: e, stackTrace: st);
      AIHelpers.showToast(msg: 'Couldn’t pick media. Please try again.');
      return null;
    }
  }

  /// Bottom sheet to choose source. Uses the *passed-in* context.
  Future<PickerAction?> _showMediaSource(BuildContext context) {
    return showModalBottomSheet<PickerAction>(
      context: context,
      useRootNavigator: true, // helps if you have nested Navigators
      builder: (sheetCtx) {
        return SafeArea(
          child: Container(
            width: double.infinity,
            color: AIColors.darkScaffoldBackground,
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () => Navigator.of(sheetCtx).pop(PickerAction.gallery),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AIImage(Icons.photo_library, color: AIColors.pink),
                      const SizedBox(width: 12.0),
                      Text(
                        'From Photos',
                        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: AIColors.pink),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24.0),
                // Stock device camera
                InkWell(
                  onTap: () => Navigator.of(sheetCtx).pop(PickerAction.camera),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AIImage(Icons.camera_alt, color: AIColors.pink),
                      const SizedBox(width: 12.0),
                      Text('From Camera',
                          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: AIColors.pink)),
                    ],
                  ),
                ),
                if (kShowDeepARButton) const SizedBox(height: 24.0),
                if (kShowDeepARButton)
                  InkWell(
                    onTap: () => Navigator.of(sheetCtx).pop(PickerAction.deepAr),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AIImage(Icons.camera_enhance, color: AIColors.pink),
                        const SizedBox(width: 12.0),
                        Text(
                          'AR Camera (DeepAR)',
                          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: AIColors.pink),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<List<XFile>> onMultiImagePicker({int? limit}) async {
    try {
      final ok = await PermissionService.requestGalleryPermission();
      if (ok == true) {
        return await _picker.pickMultiImage(limit: limit);
      } else {
        AIHelpers.showToast(msg: 'Permission denied!');
        return <XFile>[];
      }
    } catch (e, st) {
      logger.e('onMultiImagePicker error', error: e, stackTrace: st);
      return <XFile>[];
    }
  }

  Future<List<XFile>> onMultiMediaPicker({int? limit}) async {
    try {
      final ok = await PermissionService.requestGalleryPermission();
      if (ok == true) {
        // image_picker >= 1.0.7 supports optional `limit`
        return await _picker.pickMultipleMedia(limit: limit);
      } else {
        AIHelpers.showToast(msg: 'Permission denied!');
        return <XFile>[];
      }
    } catch (e, st) {
      logger.e('onMultiMediaPicker error', error: e, stackTrace: st);
      return <XFile>[];
    }
  }

  Future<List<String>> onGifPicker() async {
    try {
      final ok = await PermissionService.requestGalleryPermission();
      if (ok == true) {
        final pickerResult = await FilePicker.platform.pickFiles(
          allowMultiple: true,
          type: FileType.custom,
          allowedExtensions: const ['gif'],
        );
        if (pickerResult == null) return <String>[];
        return pickerResult.files.map((f) => f.path).whereType<String>().toList();
      } else {
        AIHelpers.showToast(msg: 'Permission denied!');
        return <String>[];
      }
    } catch (e, st) {
      logger.e('onGifPicker error', error: e, stackTrace: st);
      return <String>[];
    }
  }

}
