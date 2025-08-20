import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:stacked/stacked.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import 'package:insoblok/locator.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/utils/const.dart';


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
              ? (await uploadImageToCDN(media: media))
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
      var mediaUrl = await FirebaseHelper.uploadFile(
        file: File(media.file!.path),
        folderName: 'story',
      );

      var bytes = await File(media.file!.path).readAsBytes();
      var decodedImage = img.decodeImage(bytes);
      logger.d(decodedImage?.width);
      logger.d(decodedImage?.height);

      String? thumbUrl;
      var thumbnail = await getImageThumbnail(media.file!.path);
      if (thumbnail != null) {
        thumbUrl = await FirebaseHelper.uploadFileData(
          fileData: thumbnail,
          folderName: 'story',
        );
      }

      media.isUploaded = true;
      notifyListeners();

      return MediaStoryModel(
        link: mediaUrl,
        thumb: thumbUrl,
        width: decodedImage?.width.toDouble(),
        height: decodedImage?.height.toDouble(),
        type: 'image',
      );
    } catch (e) {
      logger.e(e);
    } finally {
      media.isUploading = false;
      notifyListeners();
    }
    return null;
  }

  // UPLOAD VIDEO
  Future<MediaStoryModel?> uploadVideo({required UploadMediaItem media}) async {
    media.isUploading = true;
    notifyListeners();
    try {
      final videoFile = File(media.file!.path);
      var vimeoService = VimeoService();
      final videoId = await vimeoService.uploadVideoToVimeo(
        videoFile,
        title: 'InSoBlokAI Video',
        description: 'Uploaded from InSoBlokAI',
      );

      String? thumbUrl;
      img.Image? decodedImage;

      var thumbnail = await getVideoThumbnail(media.file!.path);
      if (thumbnail != null) {
        decodedImage = img.decodeImage(thumbnail);
        var tempDir = await getTemporaryDirectory();
        var file = File(
          '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.png',
        );
        await file.writeAsBytes(thumbnail);
        thumbUrl = await FirebaseHelper.uploadFile(
          file: file,
          folderName: 'story',
        );
      }

      media.isUploaded = true;
      notifyListeners();

      return MediaStoryModel(
        link: 'https://player.vimeo.com/video/$videoId',
        thumb: thumbUrl,
        width: decodedImage?.width.toDouble(),
        height: decodedImage?.height.toDouble(),
        type: 'video',
      );
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

  static Future<MediaStoryModel?> uploadImageToCDN({required UploadMediaItem media}) async {
    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/${CDN_CLOUD_NAME}/image/upload');
    
    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = CDN_UPLOAD_PRESET // Create this in Cloudinary
      ..files.add(await http.MultipartFile.fromPath('file', media.file!.path));

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final Map<String, dynamic> result = jsonDecode(responseString);

      // Parse response to get public_id
      return MediaStoryModel(
        link: result["url"],
        thumb: "",
        width: result["width"],
        height: result["height"],
        type: 'image',
      );
    }
    throw Exception('Upload failed');
  }

  static Future<MediaStoryModel?> uploadVideoToCDN({required UploadMediaItem media}) async {
  final url = Uri.parse(
      'https://api.cloudinary.com/v1_1/${CDN_CLOUD_NAME}/video/upload');
  
  final request = http.MultipartRequest('POST', url)
    ..fields['upload_preset'] = CDN_UPLOAD_PRESET
    ..fields['resource_type'] = 'video' // Specify video type
    ..files.add(await http.MultipartFile.fromPath('file', media.file!.path));

  final response = await request.send();
  if (response.statusCode == 200) {
    final responseData = await response.stream.toBytes();
    final responseString = String.fromCharCodes(responseData);
    final Map<String, dynamic> result = jsonDecode(responseString);

    // Generate thumbnail URL (grabs frame at 2 seconds)
    final String publicId = result["public_id"];
    final String thumbnailUrl = 
        'https://res.cloudinary.com/${CDN_CLOUD_NAME}/video/upload/'
        'w_${result["width"]},h_${result["height"]},c_fill,so_2/'
        '$publicId.jpg';

    return MediaStoryModel(
      link: result["secure_url"] ?? result["url"], // Use secure_url if available
      thumb: thumbnailUrl,
      width: result["width"],
      height: result["height"],
      type: 'video',
    );
  }
  throw Exception('Video upload failed with status: ${response.statusCode}');
}

}
