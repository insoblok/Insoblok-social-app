// media_picker_service.dart
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

import 'package:insoblok/pages/vtos/deep_ar_plus_page.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

enum PickerAction { gallery, camera, deepAr }

class MediaPickerService {
  late BuildContext _context;
  late ImagePicker _picker;

  void init(BuildContext context) {
    _context = context;
    _picker = ImagePicker();
  }

  Future<List<XFile>> onPickerStoryMedia({int? limit}) async {
    final action = await _showMediaSource(); // ← now returns PickerAction?
    logger.d(action);

    if (action == null) return [];

    // Handle DeepAR right here and return the captured file(s)
    if (action == PickerAction.deepAr) {
      final result = await Navigator.of(_context).push<Map<String, String?>>(
        MaterialPageRoute(builder: (_) => const DeepARPlusPage()),
      );

      final medias = <XFile>[];
      if (result != null) {
        final photoPath = result['photo'];
        final videoPath = result['video'];
        if (photoPath != null && photoPath.isNotEmpty) {
          medias.add(XFile(photoPath));
        }
        if (videoPath != null && videoPath.isNotEmpty) {
          medias.add(XFile(videoPath));
        }
      }

      if (medias.isEmpty) {
        AIHelpers.showToast(msg: 'No media captured!');
      }

      logger.d("medias--- : $medias");

      return medias;
    }

    // Original flow for gallery/camera
    final isAllowed = action == PickerAction.gallery
        ? ((await PermissionService.requestGalleryPermission()) ?? false)
        : ((await PermissionService.requestCameraPermission()) ?? false);

    if (!isAllowed) {
      AIHelpers.showToast(msg: 'Permission Denied!');
      return [];
    }

    final medias = <XFile>[];
    if (action == PickerAction.camera) {
      // If you still want your platform camera picker:
      final mediaPath = await MethodChannelService.onPlatformCameraPicker();
      if (mediaPath != null) {
        logger.d(mediaPath);
        medias.add(XFile(mediaPath));
      }
    } else {
      final selects = await onMultiMediaPicker(limit: limit);
      medias.addAll(selects);
    }

    if (medias.isEmpty) {
      AIHelpers.showToast(msg: 'No selected medias!');
    }
    return medias;
  }

  Future<XFile?> onPickerSingleMedia({
    required bool isImage,
    Duration? maxDuration,
  }) async {
    final action = await _showMediaSource();
    logger.d("mediaSource = $action");
    if (action == null) return null;

    if (action == PickerAction.deepAr) {
      final result = await Navigator.of(_context).push<Map<String, String?>>(
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
      AIHelpers.showToast(msg: 'Permission Denied!');
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
  }

  Future<PickerAction?> _showMediaSource() {
    return showModalBottomSheet<PickerAction>(
      context: _context,
      builder: (context) {
        return SafeArea(
          child: Container(
            width: double.infinity,
            color: AIColors.darkScaffoldBackground,
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () => Navigator.of(context).pop(PickerAction.gallery),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AIImage(Icons.air, color: AIColors.pink),
                      const SizedBox(width: 12.0),
                      Text('From Gallery',
                        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: AIColors.pink),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24.0),
                InkWell(
                  onTap: () => {
                    Navigator.of(context).pop(PickerAction.camera),
                      // await _countdownAndRecord(context);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AIImage(Icons.camera, color: AIColors.pink),
                      const SizedBox(width: 12.0),
                      Text('From Camera',
                        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: AIColors.pink),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24.0),
                InkWell(
                  onTap: () => Navigator.of(context).pop(PickerAction.deepAr),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AIImage(Icons.camera_enhance, color: AIColors.pink),
                      const SizedBox(width: 12.0),
                      Text('From Camera (AR)',
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
    List<XFile> result = [];
    var isAllowed = await PermissionService.requestGalleryPermission();
    if (isAllowed == true) {
      result = await _picker.pickMultiImage(limit: limit);
    } else {
      AIHelpers.showToast(msg: 'Permission Denided!');
    }
    return result;
  }

  Future<List<XFile>> onMultiMediaPicker({int? limit}) async {
    List<XFile> result = [];
    var isAllowed = await PermissionService.requestGalleryPermission();
    if (isAllowed == true) {
      result = await _picker.pickMultipleMedia(limit: limit);
    } else {
      AIHelpers.showToast(msg: 'Permission Denided!');
    }
    return result;
  }

  Future<List<String>> onGifPicker() async {
    List<String> result = [];
    var isAllowed = await PermissionService.requestGalleryPermission();
    if (isAllowed == true) {
      var pickerResult = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['gif'],
      );
      if (pickerResult != null) {
        List<String?> files =
            pickerResult.files.map((file) => file.path).toList();
        for (var file in files) {
          if (file != null) {
            result.add(file);
          }
        }
      }
    } else {
      AIHelpers.showToast(msg: 'Permission Denided!');
    }
    return result;
  }

  // Somewhere in your UI before launching the camera
  // Future<void> _countdownAndRecord(BuildContext context) async {
  //   const maxSeconds = 10;

  //   // simple 3..2..1 pre-capture dialog
  //   int seconds = 3;
  //   final controller = Stream<int>.periodic(
  //     const Duration(seconds: 1),
  //     (tick) => 3 - tick,
  //   ).take(3);

  //   await showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (_) => StreamBuilder<int>(
  //       stream: controller,
  //       initialData: seconds,
  //       builder: (ctx, snap) {
  //         final n = snap.data ?? seconds;
  //         return AlertDialog(
  //           backgroundColor: Colors.black87,
  //           content: Text(
  //             n > 0 ? '$n' : 'Go!',
  //             textAlign: TextAlign.center,
  //             style: const TextStyle(fontSize: 48, color: Colors.white),
  //           ),
  //         );
  //       },
  //     ),
  //   );

  //   // now launch the native camera with a capture limit
  //   final path = await MethodChannelService.onPlatformCameraPicker(
  //     maxSeconds: maxSeconds,
  //   );

  //   // handle the returned file path
  //   if (path != null) {
  //     // do something with the recorded file...
  //   }
  // }

}
