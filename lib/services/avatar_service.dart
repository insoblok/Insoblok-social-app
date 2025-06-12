import 'dart:io';

import 'package:image_cropper/image_cropper.dart';

import 'package:insoblok/locator.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

final kAvatarAspectRatio = [
  {
    'title': '1 : 1',
    'ratio': 1,
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
  Future<String?> pickCropImage(int index) async {
    try {
      var mediaService = locator<MediaPickerService>();
      var xFile = await mediaService.onPickerSingleMedia(isImage: true);
      if (xFile == null) throw ('No selected image');
      var cropResult = await ImageCropper().cropImage(
        sourcePath: xFile.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper',
            initAspectRatio:
                kAvatarAspectRatio[index]['data'] as CropAspectRatioPresetData,
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
    } catch (e) {
      logger.e(e);
    }
    return null;
  }

  Future<String?> uploadOriginAvatar(File file) async {
    return FirebaseHelper.uploadFile(file: file);
  }

  Future<String?> createTask({
    required String fileUrl,
    String? prompt,
    required String size,
  }) async {
    var result = await NetworkUtil.createKieAvatar(
      NetworkUtil.kieGenerateMap(fileUrl: fileUrl, prompt: prompt, size: size),
    );

    logger.d(result);

    return result?['data']['taskId'];
  }

  // Status Descriptions
  // GENERATING: Generating in progress
  // SUCCESS: Generation successful
  // CREATE_TASK_FAILED: Failed to create task
  // GENERATE_FAILED: Generation failed

  Future<Map<String, dynamic>> setOnProgressListener(
    String taskId, {
    void Function(String progress)? onProgressListener,
  }) async {
    Map<String, dynamic> result = {};
    while (true) {
      var response = await NetworkUtil.getKieProgress(taskId);
      if (response == null) break;
      result = response['data'];
      if (result['status'] != 'GENERATING') break;
      if (onProgressListener != null) {
        onProgressListener(result['progress']);
      }

      await Future.delayed(const Duration(seconds: 1));
    }
    logger.d(result);
    return result;
  }

  Future<String?> downloadAvatar(String taskId, {required String url}) async {
    var response = await NetworkUtil.downloadKieAvatar(
      taskId: taskId,
      url: url,
    );
    return response?['data'];
  }

  Future<String?> uploadResultAvatar(String url) async {
    return FirebaseHelper.uploadImageFromUrl(imageUrl: url);
  }
}
