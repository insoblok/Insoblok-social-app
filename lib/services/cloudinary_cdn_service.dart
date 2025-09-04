import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:insoblok/utils/const.dart';
import 'package:insoblok/models/models.dart';
import 'package:video_compress/video_compress.dart';

class CloudinaryCDNService {

  static Future<MediaStoryModel> uploadImageToCDN(XFile file) async {
    debugPrint("Image size is ${await file.length()}");
    if(await file.length() < CDN_IMG_UPLOAD_MAX_LIMIT) {
      try {
        final url = Uri.parse(
          'https://api.cloudinary.com/v1_1/${CDN_CLOUD_NAME}/image/upload');
      
      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = CDN_UPLOAD_PRESET // Create this in Cloudinary
        ..files.add(await http.MultipartFile.fromPath('file', file.path));

      final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);
        final Map<String, dynamic> result = jsonDecode(responseString);

        // Parse response to get public_id
        return MediaStoryModel(
          link: result["url"],
          thumb: "",
          width: result["width"].toDouble(),
          height: result["height"].toDouble(),
          type: 'image'
        );
      }
      } catch (e) {
        debugPrint('Upload failed due to $e');
      }
    }
    return MediaStoryModel(
      link: "",
      thumb: "",
      width: 0,
      height: 0,
      type: 'image'
    );
  }

  static Future<MediaStoryModel> uploadVideoToCDN(XFile file) async {
    try {
          MediaInfo? mediaInfo = await VideoCompress.compressVideo(
            file.path,
            quality: VideoQuality.Res640x480Quality, 
            deleteOrigin: false,
          );
      debugPrint("Compressed size is ${await file.length()} ====> ${mediaInfo!.filesize}");
      // Check if the operation was successful and the file was created
      if (await mediaInfo.file!.exists() && mediaInfo.filesize! < CDN_VIDEO_UPLOAD_MAX_LIMIT) {
        final url = Uri.parse(
          'https://api.cloudinary.com/v1_1/${CDN_CLOUD_NAME}/video/upload');
      
        final request = http.MultipartRequest('POST', url)
          ..fields['upload_preset'] = CDN_UPLOAD_PRESET
          ..fields['resource_type'] = 'video' // Specify video type
          ..files.add(await http.MultipartFile.fromPath('file', mediaInfo.file!.path));

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
            link: result["url"], // Use secure_url if available
            thumb: thumbnailUrl,
            width: result["width"].toDouble(),
            height: result["height"].toDouble(),
            type: 'video',
          ); // Return the path to the compressed video
        } 
      } 
    } catch (e) {
        debugPrint("FFmpeg compression error: $e");
    }
      return MediaStoryModel(
        link: "",
        thumb: "",
        width: 0,
        height: 0,
        type: "video"
      );
    
  }

  static Future<MediaStoryModel> uploadImageFromUrl(String imageUrl) async {
    final tempFile = await _downloadImage(imageUrl);
    return uploadImageToCDN(XFile(tempFile.path));

  }

  static Future<File> _downloadImage(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      
      if (response.statusCode != 200) {
        throw Exception('Failed to download image: ${response.statusCode}');
      }

      // Create temporary file
      final tempDir = await Directory.systemTemp.createTemp();
      final tempFile = File('${tempDir.path}/temp_image.jpg');
      
      // Write downloaded data to file
      await tempFile.writeAsBytes(response.bodyBytes);
      
      return tempFile;
    } catch (e) {
      print('Error downloading image: $e');
      throw Exception('Failed to download image from URL');
    }
  }

}
