import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class MediaPickerService {
  late BuildContext _context;
  late ImagePicker _picker;

  MediaPickerService(BuildContext context) {
    _context = context;
    _picker = ImagePicker();
  }

  Future<XFile?> onPickerSingleMedia({required bool isImage}) async {
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
          media = await _picker.pickVideo(source: mediaSource);
        }

        if (media != null) {
          return media;
        } else {
          Fluttertoast.showToast(
            msg: 'No selected ${isImage ? 'image' : 'video'}!',
          );
        }
      } else {
        Fluttertoast.showToast(msg: 'Permission Denided!');
      }
    }
    return null;
  }

  Future<ImageSource?> _showMediaSource() async {
    return await showModalBottomSheet<ImageSource>(
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
      Fluttertoast.showToast(msg: 'Permission Denided!');
    }
    return result;
  }

  Future<List<XFile>> onMultiMediaPicker({int? limit}) async {
    List<XFile> result = [];
    var isAllowed = await PermissionService.requestGalleryPermission();
    if (isAllowed == true) {
      result = await _picker.pickMultipleMedia(limit: limit);
    } else {
      Fluttertoast.showToast(msg: 'Permission Denided!');
    }
    return result;
  }
}
