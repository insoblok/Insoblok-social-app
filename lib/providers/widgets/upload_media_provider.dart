import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';

import 'package:insoblok/locator.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class UploadMediaItem {
  final XFile? file;

  bool isUploading = false;
  bool isUploaded = false;

  UploadMediaItem({this.file});
}

class UploadMediaProvider extends ReactiveViewModel {
  late BuildContext context;
  final _mediaPicker = locator<MediaPickerService>();

  void init(BuildContext context) {
    this.context = context;
    _mediaPicker.init(context);
  }

  List<UploadMediaItem> medias = [];

  // * PICK IMAGES FROM GALLERY
  Future<void> addMedias({String? title, int? maxImages}) async {
    var files = await _mediaPicker.onPickerStoryMedia(
      limit: (maxImages ?? 9 - medias.length),
    );
    if (files.isEmpty) {
      AIHelpers.showToast(msg: 'No selected media!');
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
      var mediaPath = media.file!.path;
      var mediaType =
          ((mediaPath.endsWith('png')) ||
                  mediaPath.endsWith('jpg') ||
                  mediaPath.endsWith('jpeg'))
              ? 'image'
              : 'video';

      if (media.isUploaded) continue;
      var url = await uploadMedia(media: media);

      if (mediaType == 'image') {
        var bytes = await File(mediaPath).readAsBytes();
        var decodedImage = img.decodeImage(bytes);

        if (decodedImage != null) {
          logger.d(decodedImage.width);
          logger.d(decodedImage.height);
          if (url != null) {
            var model = MediaStoryModel(
              link: url,
              type: mediaType,
              width: decodedImage.width.toDouble(),
              height: decodedImage.height.toDouble(),
            );
            result.add(model);
          }
        }
      } else {
        if (url != null) {
          var model = MediaStoryModel(link: url, type: mediaType);
          result.add(model);
        }
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
