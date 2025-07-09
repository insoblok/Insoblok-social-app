import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class VimeoService {
  Future<String?> uploadVideoToVimeo(
    File videoFile, {
    String? title,
    String? description,
  }) async {
    String apiUrl = 'https://api.vimeo.com';
    try {
      final createResponse = await http.post(
        Uri.parse('$apiUrl/me/videos'),
        headers: {
          'Authorization': 'Bearer $VIMEO_ACCESS_TOKEN',
          'Accept': 'application/vnd.vimeo.*+json;version=3.4',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'upload': {
            'approach': 'tus',
            'size': videoFile.lengthSync().toString(),
          },
          'name': title ?? 'Untitled',
          'description': description ?? '',
        }),
      );

      if (createResponse.statusCode != 200) {
        throw Exception('Failed to create video: ${createResponse.body}');
      }

      final createData = jsonDecode(createResponse.body);
      final uploadLink = createData['upload']['upload_link'];

      logger.d(uploadLink);

      // Step 2: Upload the video file using tus protocol
      // final mimeType = lookupMimeType(videoFile.path) ?? 'video/mp4';

      var uploadResponse = await http.patch(
        Uri.parse(uploadLink),
        headers: {
          'Content-Type': 'application/offset+octet-stream',
          'Tus-Resumable': '1.0.0',
          'Upload-Offset': '0',
        },
        body: await videoFile.readAsBytes(),
      );

      if (uploadResponse.statusCode != 204) {
        throw Exception('Upload failed: ${uploadResponse.body}');
      }

      return createData['uri'].toString().split('/').last; // returns video ID
    } catch (e) {
      logger.e('Vimeo upload error: $e');
      return null;
    }
  }

  Future<String?> uploadVideoToWistia(
    File videoFile, {
    String? title,
    String? description,
  }) async {
    var uri = Uri.parse('https://upload.wistia.com');
    var request =
        http.MultipartRequest('POST', uri)
          ..headers.addAll({'Authorization': 'Bearer $WISITIA_ACCESS_TOKEN'})
          ..files.add(
            await http.MultipartFile.fromPath('file', videoFile.path),
          );

    var response = await request.send();

    if (response.statusCode == 200) {
      logger.d('Upload successful');
    } else {
      logger.d('Upload failed with status: ${response.statusCode}');
    }

    return null;
  }
}

// Future<void> uploadVideo() async {
//   final videoFile = File('/path/to/your/video.mp4');
//   final uploader = VimeoUploader();
  
//   try {
//     final videoId = await uploader.uploadVideo(
//       videoFile,
//       title: 'My Flutter Video',
//       description: 'Uploaded from my Flutter app',
//     );
    
//     if (videoId != null) {
//       print('Video uploaded successfully! ID: $videoId');
//       print('View at: https://vimeo.com/$videoId');
//     } else {
//       print('Upload failed');
//     }
//   } catch (e) {
//     print('Error: $e');
//   }
// }