import 'dart:io';

import 'package:mime/mime.dart';
import 'package:image_cropper/image_cropper.dart';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'package:insoblok/services/cloudinary_cdn_service.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/models/models.dart';


final kAvatarAspectRatio = [
  {
    'title': '1 : 1',
    'ratio': 1.0,
    'data': CropAspectRatioPreset.square,
    'size': '1:1',
  },
  {
    'title': '3 : 2',
    'ratio': 3 / 2,
    'data': CropAspectRatioPreset.ratio3x2,
    'size': '3:2',
  },
  {
    'title': '2 : 3',
    'ratio': 2 / 3,
    'data': CropAspectRatioPresetRatio23(),
    'size': '2:3',
  },
];

class CropAspectRatioPresetRatio23 implements CropAspectRatioPresetData {
  @override
  (int, int)? get data => (2, 3);

  @override
  String get name => '2x3 (customized)';
}

class AvatarService {
  Future<String?> pickCropImage(BuildContext context, int index) async {
    try {
      final mediaService = MediaPickerService();

      // ⬇️ PASS CONTEXT HERE
      final xFile = await mediaService.onPickerSingleMedia(
        context,
        isImage: true,
      );
      if (xFile == null) {
        AIHelpers.showToast(msg: 'No selected image');
        return null;
      }

      final cropResult = await ImageCropper().cropImage(
        sourcePath: xFile.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper',
            initAspectRatio: kAvatarAspectRatio[index]['data'] as CropAspectRatioPresetData,
            hideBottomControls: true,
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPresetRatio23(),
            ],
          ),
          IOSUiSettings(
            title: 'Cropper',
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPresetRatio23(),
            ],
          ),
        ],
      );
      return cropResult?.path;
    } catch (e, st) {
      logger.e('pickCropImage error', error: e, stackTrace: st);
      return null;
    }
  }

  Future<String?> uploadOriginAvatar(File file) async {
    final type = lookupMimeType(file.path);
    MediaStoryModel? model;
    if ((type ?? "").startsWith("image/")) {
      model = await CloudinaryCDNService.uploadImageToCDN(XFile(file.path));
    }
    else if ((type ?? "").startsWith("video/")) {
      model = await CloudinaryCDNService.uploadVideoToCDN(XFile(file.path));
    }
    return model?.link;
  }

  Future<String?> createTask({
    required String fileUrl,
    String? prompt,
    required String size,
  }) async {
    final result = await NetworkUtil.createKieAvatar(
      NetworkUtil.kieGenerateMap(fileUrl: fileUrl, prompt: prompt, size: size),
    );
    logger.d(result);
    return result?['data']['taskId'];
  }

  Future<Map<String, dynamic>> setOnProgressListener(
    String taskId, {
    void Function(String progress)? onProgressListener,
  }) async {
    Map<String, dynamic> result = {};
    while (true) {
      final response = await NetworkUtil.getKieProgress(taskId);
      if (response == null) break;
      result = response['data'];
      if (result['status'] != 'GENERATING') break;
      onProgressListener?.call(result['progress']);
      await Future.delayed(const Duration(seconds: 1));
    }
    logger.d(result);
    return result;
  }

  Future<String?> downloadAvatar(String taskId, {required String url}) async {
    final response = await NetworkUtil.downloadKieAvatar(taskId: taskId, url: url);
    return response?['data'];
  }

  Future<String?> uploadResultAvatar(String url) async {
    final model = await CloudinaryCDNService.uploadImageFromUrl(url);
    return model.link;
  }
}
