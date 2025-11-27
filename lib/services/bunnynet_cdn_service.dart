import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:insoblok/utils/const.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';
import 'package:video_compress/video_compress.dart';

class BunnyNetCDNService {
  /// Uploads an image file to bunny.net storage
  /// Returns MediaStoryModel with the CDN URL
  static Future<MediaStoryModel> uploadImageToCDN(XFile file) async {
    final fileSize = await file.length();
    logger.d(
      "📤 Starting bunny.net image upload - size: $fileSize bytes, path: ${file.path}",
    );

    // Check file size limit
    if (fileSize >= CDN_IMG_UPLOAD_MAX_LIMIT) {
      logger.e(
        '❌ Image file too large: $fileSize bytes (max: $CDN_IMG_UPLOAD_MAX_LIMIT)',
      );
      return MediaStoryModel(
        link: "",
        thumb: "",
        width: 0,
        height: 0,
        type: 'image',
      );
    }

    // Check if file exists
    final fileExists = await File(file.path).exists();
    if (!fileExists) {
      logger.e('❌ File does not exist: ${file.path}');
      return MediaStoryModel(
        link: "",
        thumb: "",
        width: 0,
        height: 0,
        type: 'image',
      );
    }

    try {
      // Generate unique filename with timestamp
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath = file.path;
      final extension =
          filePath.contains('.')
              ? filePath.substring(filePath.lastIndexOf('.'))
              : '.jpg';
      final baseName =
          filePath.contains('/')
              ? filePath.substring(filePath.lastIndexOf('/') + 1)
              : filePath;
      final nameWithoutExt =
          baseName.contains('.')
              ? baseName.substring(0, baseName.lastIndexOf('.'))
              : baseName;
      final fileName = 'images/${timestamp}_$nameWithoutExt$extension';

      // Read file bytes
      final fileBytes = await File(file.path).readAsBytes();

      // Get image dimensions
      final image = img.decodeImage(fileBytes);
      final width = image != null ? image.width.toDouble() : 0.0;
      final height = image != null ? image.height.toDouble() : 0.0;

      // Upload to bunny.net storage
      // Use storage.bunnycdn.com for uploads (requires AccessKey)
      final uploadUrl = Uri.parse(
        'https://storage.bunnycdn.com/${BUNNYNET_STORAGE_ZONE_NAME}/$fileName',
      );

      logger.d('📡 Uploading to bunny.net: $uploadUrl');

      // Use PUT request with raw file bytes (not multipart)
      final request =
          http.Request('PUT', uploadUrl)
            ..headers['AccessKey'] = BUNNYNET_API_KEY
            ..headers['Content-Type'] = _getContentType(extension)
            ..bodyBytes = fileBytes;

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      logger.d('📥 Response status: ${response.statusCode}');
      logger.d('📥 Response body: $responseBody');

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Construct CDN URL for public access
        // bunny.net storage zones can be accessed via {storageZoneName}.b-cdn.net
        // OR if a pull zone is configured, use the pull zone hostname
        // Format: https://{storageZoneName}.b-cdn.net/{path}
        // Note: Make sure the storage zone is set to "Public" in bunny.net dashboard
        // URL-encode the file path to handle spaces and special characters
        final cdnHostname =
            BUNNYNET_CDN_HOSTNAME.isNotEmpty &&
                    !BUNNYNET_CDN_HOSTNAME.contains('storage.bunnycdn.com')
                ? BUNNYNET_CDN_HOSTNAME
                : '${BUNNYNET_STORAGE_ZONE_NAME}.b-cdn.net';
        // Split path and encode each segment separately to preserve slashes
        final pathSegments = fileName.split('/');
        final encodedPath = pathSegments
            .map((segment) => Uri.encodeComponent(segment))
            .join('/');
        final cdnUrl = 'https://$cdnHostname/$encodedPath';

        logger.d('✅ Upload successful! URL: $cdnUrl, Size: ${width}x${height}');
        logger.d(
          '📝 Note: Ensure storage zone "${BUNNYNET_STORAGE_ZONE_NAME}" is set to "Public" in bunny.net dashboard',
        );

        return MediaStoryModel(
          link: cdnUrl,
          thumb: cdnUrl, // Use same URL for thumbnail
          width: width,
          height: height,
          type: 'image',
        );
      } else {
        logger.e(
          '❌ bunny.net upload failed: HTTP ${response.statusCode} - $responseBody',
        );
        return MediaStoryModel(
          link: "",
          thumb: "",
          width: 0,
          height: 0,
          type: 'image',
        );
      }
    } catch (e, stackTrace) {
      logger.e('❌ Image upload exception: $e');
      logger.e('📚 Stack trace: $stackTrace');
      return MediaStoryModel(
        link: "",
        thumb: "",
        width: 0,
        height: 0,
        type: 'image',
      );
    }
  }

  /// Uploads a video file to bunny.net storage
  /// Returns MediaStoryModel with the CDN URL and thumbnail
  static Future<MediaStoryModel> uploadVideoToCDN(XFile file) async {
    try {
      // Check if file exists
      if (!await File(file.path).exists()) {
        throw Exception('Video file does not exist: ${file.path}');
      }

      MediaInfo? mediaInfo = await VideoCompress.compressVideo(
        file.path,
        quality: VideoQuality.Res640x480Quality,
        deleteOrigin: false,
      );

      if (mediaInfo == null || mediaInfo.file == null) {
        throw Exception('Video compression failed: mediaInfo is null');
      }

      debugPrint(
        "Compressed size is ${await file.length()} ====> ${mediaInfo.filesize}",
      );

      // Check if the operation was successful and the file was created
      if (!await mediaInfo.file!.exists()) {
        throw Exception(
          'Compressed video file does not exist: ${mediaInfo.file!.path}',
        );
      }

      if (mediaInfo.filesize != null &&
          mediaInfo.filesize! >= CDN_VIDEO_UPLOAD_MAX_LIMIT) {
        throw Exception(
          'Video file too large: ${mediaInfo.filesize} bytes (max: $CDN_VIDEO_UPLOAD_MAX_LIMIT)',
        );
      }

      // Generate unique filename with timestamp
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath = mediaInfo.file!.path;
      final extension =
          filePath.contains('.')
              ? filePath.substring(filePath.lastIndexOf('.'))
              : '.mp4';
      final baseName =
          filePath.contains('/')
              ? filePath.substring(filePath.lastIndexOf('/') + 1)
              : filePath;
      final nameWithoutExt =
          baseName.contains('.')
              ? baseName.substring(0, baseName.lastIndexOf('.'))
              : baseName;
      final fileName = 'videos/${timestamp}_$nameWithoutExt$extension';

      // Read video file bytes
      final videoBytes = await mediaInfo.file!.readAsBytes();

      // Upload video to bunny.net storage
      // Use storage.bunnycdn.com for uploads (requires AccessKey)
      final uploadUrl = Uri.parse(
        'https://storage.bunnycdn.com/${BUNNYNET_STORAGE_ZONE_NAME}/$fileName',
      );

      logger.d('📡 Uploading video to bunny.net: $uploadUrl');

      // Use PUT request with raw file bytes (not multipart)
      final request =
          http.Request('PUT', uploadUrl)
            ..headers['AccessKey'] = BUNNYNET_API_KEY
            ..headers['Content-Type'] = 'video/mp4'
            ..bodyBytes = videoBytes;

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      logger.d('📥 Video upload response status: ${response.statusCode}');
      logger.d('📥 Video upload response body: $responseBody');

      if (response.statusCode != 201 && response.statusCode != 200) {
        debugPrint('bunny.net upload failed: HTTP ${response.statusCode}');
        debugPrint('Response: $responseBody');
        throw Exception(
          'bunny.net upload failed: HTTP ${response.statusCode} - $responseBody',
        );
      }

      // Construct CDN URL for public access
      // bunny.net storage zones can be accessed via {storageZoneName}.b-cdn.net
      // OR if a pull zone is configured, use the pull zone hostname
      // Format: https://{storageZoneName}.b-cdn.net/{path}
      // Note: Make sure the storage zone is set to "Public" in bunny.net dashboard
      // URL-encode the file path to handle spaces and special characters
      final cdnHostname =
          BUNNYNET_CDN_HOSTNAME.isNotEmpty &&
                  !BUNNYNET_CDN_HOSTNAME.contains('storage.bunnycdn.com')
              ? BUNNYNET_CDN_HOSTNAME
              : '${BUNNYNET_STORAGE_ZONE_NAME}.b-cdn.net';
      // Split path and encode each segment separately to preserve slashes
      final pathSegments = fileName.split('/');
      final encodedPath = pathSegments
          .map((segment) => Uri.encodeComponent(segment))
          .join('/');
      final videoUrl = 'https://$cdnHostname/$encodedPath';

      logger.d(
        '📝 Note: Ensure storage zone "${BUNNYNET_STORAGE_ZONE_NAME}" is set to "Public" in bunny.net dashboard',
      );

      // Generate thumbnail (for bunny.net, we'll use the video URL as thumbnail for now)
      // In the future, you might want to extract a frame and upload it separately
      final thumbnailUrl = videoUrl; // Placeholder - can be enhanced later

      // Get video dimensions from mediaInfo
      final width = mediaInfo.width?.toDouble() ?? 0.0;
      final height = mediaInfo.height?.toDouble() ?? 0.0;

      logger.d(
        '✅ Video upload successful! URL: $videoUrl, Size: ${width}x${height}',
      );

      return MediaStoryModel(
        link: videoUrl,
        thumb: thumbnailUrl,
        width: width,
        height: height,
        type: 'video',
      );
    } catch (e, stackTrace) {
      debugPrint("Video upload error: $e");
      debugPrint("Stack trace: $stackTrace");
      rethrow; // Re-throw to let caller handle the error
    }
  }

  /// Helper method to get content type based on file extension
  static String _getContentType(String extension) {
    switch (extension.toLowerCase()) {
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.png':
        return 'image/png';
      case '.gif':
        return 'image/gif';
      case '.webp':
        return 'image/webp';
      case '.mp4':
        return 'video/mp4';
      case '.mov':
        return 'video/quicktime';
      default:
        return 'application/octet-stream';
    }
  }

  /// Uploads an image from a URL to bunny.net
  /// Downloads the image from the given URL and uploads it to bunny.net
  static Future<MediaStoryModel> uploadImageFromUrl(String imageUrl) async {
    try {
      logger.d('📥 Downloading image from URL: $imageUrl');

      // Download the image file
      final response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to download image: HTTP ${response.statusCode}',
        );
      }

      // Create temporary file
      final tempDir = await Directory.systemTemp.createTemp();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final tempFile = File('${tempDir.path}/temp_image_$timestamp.jpg');

      // Write downloaded data to file
      await tempFile.writeAsBytes(response.bodyBytes);

      logger.d('✅ Image downloaded successfully: ${tempFile.path}');

      // Upload to bunny.net using XFile
      final xFile = XFile(tempFile.path);
      final result = await uploadImageToCDN(xFile);

      // Clean up temporary file
      try {
        await tempFile.delete();
        await tempDir.delete(recursive: true);
      } catch (e) {
        logger.w('⚠️ Failed to clean up temp file: $e');
      }

      return result;
    } catch (e, stackTrace) {
      logger.e('❌ Error uploading image from URL: $e');
      logger.e('📚 Stack trace: $stackTrace');
      return MediaStoryModel(
        link: "",
        thumb: "",
        width: 0,
        height: 0,
        type: 'image',
      );
    }
  }

  /// Uploads a video from a URL to bunny.net
  /// Downloads the video from the given URL and uploads it to bunny.net
  static Future<MediaStoryModel> uploadVideoFromUrl(String videoUrl) async {
    try {
      logger.d('📥 Downloading video from URL: $videoUrl');

      // Download the video file
      final response = await http.get(Uri.parse(videoUrl));

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to download video: HTTP ${response.statusCode}',
        );
      }

      // Create temporary file
      final tempDir = await Directory.systemTemp.createTemp();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final tempFile = File('${tempDir.path}/temp_video_$timestamp.mp4');

      // Write downloaded data to file
      await tempFile.writeAsBytes(response.bodyBytes);

      logger.d('✅ Video downloaded successfully: ${tempFile.path}');

      // Upload to bunny.net using XFile
      final xFile = XFile(tempFile.path);
      final result = await uploadVideoToCDN(xFile);

      // Clean up temporary file
      try {
        await tempFile.delete();
        await tempDir.delete(recursive: true);
      } catch (e) {
        logger.w('⚠️ Failed to clean up temp file: $e');
      }

      return result;
    } catch (e, stackTrace) {
      logger.e('❌ Error uploading video from URL: $e');
      logger.e('📚 Stack trace: $stackTrace');
      return MediaStoryModel(
        link: "",
        thumb: "",
        width: 0,
        height: 0,
        type: 'video',
      );
    }
  }

  /// Checks if a URL is from bunny.net
  static bool isBunnyNetUrl(String url) {
    final cdnPattern = '${BUNNYNET_STORAGE_ZONE_NAME}.b-cdn.net';
    return url.contains(cdnPattern) ||
        url.contains('b-cdn.net') ||
        url.contains('storage.bunnycdn.com');
  }

  /// Checks if a URL is from Cloudinary
  static bool isCloudinaryUrl(String url) {
    return url.contains('cloudinary.com') || url.contains('res.cloudinary.com');
  }
}
