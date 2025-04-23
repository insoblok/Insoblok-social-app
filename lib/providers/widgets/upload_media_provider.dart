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

  List<UploadMediaItem> _medias = [];
  List<UploadMediaItem> get medias => _medias;

  // * PICK IMAGES FROM GALLERY
  Future<void> addMedias(
    BuildContext context, {
    String? title,
    int? maxImages,
  }) async {
    var files = await _mediaPicker.onMultiMediaPicker(
      limit: (9 - _medias.length),
    );
    if (files.isEmpty) {
      Fluttertoast.showToast(msg: 'No selected media!');
    } else {
      _medias.addAll(
        files.map((asset) => UploadMediaItem(file: asset)).toList(),
      );
    }
    logger.d(_medias.length);
    notifyListeners();
  }

  void removeMedia(UploadMediaItem media) {
    if (!media.isUploaded && !media.isUploaded) {
      _medias.remove(media);
      notifyListeners();
    }
  }

  Future<List<MediaStoryModel>> uploadMedias() async {
    List<MediaStoryModel> result = [];
    for (var media in _medias) {
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
    try {
      // await NetworkHelpers.uploadImage(
      //   venueId: venueId,
      //   eventId: eventId,
      //   reviewId: reviewId,
      //   listingId: listingId,
      //   image: image.compressedImage,
      //   type: image.imageType,
      //   onSentProgress: (int sent, int total) {},
      // );

      await Future.delayed(const Duration(milliseconds: 1500));

      media.isUploaded = true;
    } catch (e) {
      logger.e(e);
    } finally {
      media.isUploading = false;
      notifyListeners();
    }
    return null;
  }

  void reset() {
    _medias = [];
    setError(null);
  }

  @override
  void dispose() {
    reset();
    super.dispose();
  }
}
