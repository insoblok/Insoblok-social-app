import 'package:flutter/material.dart';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class MediaPickerService {
  late BuildContext _context;
  late ImagePicker _picker;

  void init(BuildContext context) {
    _context = context;
    _picker = ImagePicker();
  }

  Future<List<XFile>> onPickerStoryMedia({int? limit}) async {
    var mediaSource = await _showMediaSource();
    logger.d(mediaSource);

    if (mediaSource != null) {
      var isAllowed = false;
      isAllowed =
          mediaSource == ImageSource.gallery
              ? ((await PermissionService.requestGalleryPermission()) ?? false)
              : ((await PermissionService.requestCameraPermission()) ?? false);

      if (isAllowed) {
        List<XFile> medias = [];
        if (mediaSource == ImageSource.camera) {
          // var media = await _picker.pickVideo(
          //   source: mediaSource,
          //   maxDuration: const Duration(seconds: 10),
          // );
          // if (media != null) {
          //   medias.add(media);
          // }
          var mediaPath = await MethodChannelService.onPlatformCameraPicker();
          if (mediaPath != null) {
            logger.d(mediaPath);
            var media = XFile(mediaPath);
            medias.add(media);
          }
        } else {
          var selects = await onMultiMediaPicker(limit: limit);
          medias.addAll(selects);
        }

        if (medias.isEmpty) {
          AIHelpers.showToast(msg: 'No selected medias!');
        }
        return medias;
      } else {
        AIHelpers.showToast(msg: 'Permission Denided!');
      }
    }
    return [];
  }

  Future<XFile?> onPickerSingleMedia({
    required bool isImage,
    Duration? maxDuration,
  }) async {
    var mediaSource = await _showMediaSource();
    if (mediaSource != null) {
      var isAllowed = false;
      isAllowed =
          mediaSource == ImageSource.gallery
              ? ((await PermissionService.requestGalleryPermission()) ?? false)
              : ((await PermissionService.requestCameraPermission()) ?? false);

      if (isAllowed) {
        XFile? media;
        if (isImage) {
          media = await _picker.pickImage(source: mediaSource);
        } else {
          media = await _picker.pickVideo(
            source: mediaSource,
            maxDuration: maxDuration,
          );
        }

        if (media != null) {
          return media;
        } else {
          AIHelpers.showToast(
            msg: 'No selected ${isImage ? 'image' : 'video'}!',
          );
        }
      } else {
        AIHelpers.showToast(msg: 'Permission Denided!');
      }
    }
    return null;
  }

  Future<ImageSource?> _showMediaSource() {
    return showModalBottomSheet<ImageSource>(
      context: _context,
      builder: (context) {
        return SafeArea(
          child: Container(
            width: double.infinity,
            color: AIColors.darkScaffoldBackground,
            padding: const EdgeInsets.symmetric(
              horizontal: 18.0,
              vertical: 24.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () => Navigator.of(context).pop(ImageSource.gallery),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AIImage(Icons.air, color: AIColors.pink),
                      const SizedBox(width: 12.0),
                      Text(
                        'From Gallery',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: AIColors.pink,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24.0),
                InkWell(
                  onTap: () => Navigator.of(context).pop(ImageSource.camera),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AIImage(Icons.camera, color: AIColors.pink),
                      const SizedBox(width: 12.0),
                      Text(
                        'From Camera',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: AIColors.pink,
                        ),
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
}
