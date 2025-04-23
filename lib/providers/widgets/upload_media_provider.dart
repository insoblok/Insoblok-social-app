import 'dart:io';

import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class UploadMediaItem {
  final XFile? file;

  bool isUploading = false;
  bool isUploaded = false;

  UploadMediaItem({this.file});
}

class UploadMediaProvider extends InSoBlokViewModel {
  late MediaPickerService _mediaPicker;

  Future<void> init(BuildContext context) async {
    reset();
    _mediaPicker = MediaPickerService(context);
  }

  List<UploadMediaItem> medias = [];

  // * PICK IMAGES FROM GALLERY
  Future<void> addMedias(
    BuildContext context, {
    String? title,
    int? maxImages,
  }) async {
    var files = await _mediaPicker.onMultiMediaPicker(
      limit: (9 - medias.length),
    );
    if (files.isEmpty) {
      Fluttertoast.showToast(msg: 'No selected media!');
    } else {
      medias.addAll(
        files.map((asset) => UploadMediaItem(file: asset)).toList(),
      );
    }
    logger.d(medias.length);
    notifyListeners();
  }

  void removeMedia(UploadMediaItem media) {
    if (!media.isUploaded && !media.isUploaded) {
      medias.remove(media);
      notifyListeners();
    }
  }

  Future<List<MediaStoryModel>> uploadMedias() async {
    List<MediaStoryModel> result = [];
    for (var media in medias) {
      if (media.isUploaded) continue;
      var url = await uploadMedia(media: media);

      if (url != null) {
        var type = media.file?.mimeType;

        var model = MediaStoryModel(
          link: url,
          type:
              (type == 'png' || type == 'jpg' || type == 'jpeg')
                  ? 'image'
                  : 'video',
        );
        result.add(model);
      }
    }
    return result;
  }

  // UPLOAD IMAGE
  Future<String?> uploadMedia({required UploadMediaItem media}) async {
    media.isUploading = true;
    notifyListeners();
    try {
      var mediaUrl = await FirebaseHelper.uploadFile(
        file: File(media.file!.path),
        folderName: 'story',
      );
      media.isUploaded = true;
      notifyListeners();

      return mediaUrl;
    } catch (e) {
      logger.e(e);
    } finally {
      media.isUploading = false;
      notifyListeners();
    }
    return null;
  }

  void reset() {
    medias.clear();
    setError(null);
  }

  @override
  void dispose() {
    reset();
    super.dispose();
  }
}
