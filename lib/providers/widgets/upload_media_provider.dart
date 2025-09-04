import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:stacked/stacked.dart';
import 'package:insoblok/services/cloudinary_cdn_service.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

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
    logger.d("uploaded medias-----------");
    logger.d(medias.length);
    notifyListeners();
  }

  void removeMedia(UploadMediaItem media) {
    if (!media.isUploaded && !media.isUploaded) {
      medias.remove(media);
      notifyListeners();
    }
  }

  void removeMediaByIndex(int index) {
    if(index < medias.length) medias.removeAt(index);
  }

  Future<List<MediaStoryModel>> uploadMedias() async {
    List<MediaStoryModel> result = [];
    for (var media in medias) {
      var mediaPath = media.file!.path;
      var mediaType =
          (mediaPath.endsWith('mp4') || mediaPath.endsWith('mov'))
              ? 'video'
              : 'image';

      if (media.isUploaded) continue;
      var model =
          mediaType == 'image'
              ? (await uploadImage(media: media))
              : (await uploadVideo(media: media));

      if (model != null) {
        result.add(model);
      }
    }
    return result;
  }

  Future<Uint8List?> getVideoThumbnail(String videoPath) async {
    final thumbnail = await VideoThumbnail.thumbnailData(
      video: videoPath,
      imageFormat: ImageFormat.PNG,
      quality: 80,
      timeMs: 1000,
    );
    return thumbnail;
  }

  Future<Uint8List?> getImageThumbnail(String imagePath) async {
    var file = File('${imagePath}_thumbnail.jpg');
    if (!file.existsSync()) {
      await file.create();
    }

    final result = await FlutterImageCompress.compressAndGetFile(
      imagePath,
      '${imagePath}_thumbnail.jpg',
      quality: 60,
      minWidth: 200,
      minHeight: 200,
    );
    logger.d(result?.mimeType);
    return result?.readAsBytes();
  }

  // UPLOAD IMAGE
  Future<MediaStoryModel?> uploadImage({required UploadMediaItem media}) async {
    media.isUploading = true;
    notifyListeners();
    try {

      // var mediaUrl = await FirebaseHelper.uploadFile(
      //   file: File(media.file!.path),
      //   folderName: 'story',
      // );
      MediaStoryModel model = await CloudinaryCDNService.uploadImageToCDN(media.file!);

      // var bytes = await File(media.file!.path).readAsBytes();
      // var decodedImage = img.decodeImage(bytes);
      // logger.d(decodedImage?.width);
      // logger.d(decodedImage?.height);

      // String? thumbUrl;
      // var thumbnail = await getImageThumbnail(media.file!.path);
      // if (thumbnail != null) {
      //   thumbUrl = await FirebaseHelper.uploadFileData(
      //     fileData: thumbnail,
      //     folderName: 'story',
      //   );
      // }

      media.isUploaded = true;
      notifyListeners();

      return MediaStoryModel(
        link: model.link,
        thumb: "",
        width: model.width,
        height: model.height,
        type: 'image',
      );
    } catch (e) {
      logger.e(e);
    } finally {
      media.isUploading = false;
      notifyListeners();
    }
    return MediaStoryModel(
        link: "",
        thumb: "",
        width: 0,
        height: 0,
        type: 'image',
      );
  }

  // UPLOAD VIDEO
  Future<MediaStoryModel?> uploadVideo({required UploadMediaItem media}) async {
    media.isUploading = true;
    notifyListeners();
    try {
      // final videoFile = File(media.file!.path);
      // final videoId = await vimeoService.uploadVideoToVimeo(
      //   videoFile,
      //   title: 'InSoBlokAI Video',
      //   description: 'Uploaded from InSoBlokAI',
      // );
      MediaStoryModel model = await CloudinaryCDNService.uploadVideoToCDN(media.file!);
      media.isUploaded = true;
      notifyListeners();

      return model;
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
