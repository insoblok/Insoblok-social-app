import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/services/bunnynet_cdn_service.dart';

class CloudinaryCDNService {
  /// Uploads image to bunny.net
  /// All new uploads are routed to bunny.net
  static Future<MediaStoryModel> uploadImageToCDN(XFile file) async {
    logger.d('📤 Routing image upload to bunny.net');
    return BunnyNetCDNService.uploadImageToCDN(file);
  }

  /// Uploads video to bunny.net
  /// All new uploads are routed to bunny.net
  static Future<MediaStoryModel> uploadVideoToCDN(XFile file) async {
    logger.d('📤 Routing video upload to bunny.net');
    return BunnyNetCDNService.uploadVideoToCDN(file);
  }

  static Future<MediaStoryModel> uploadImageFromUrl(String imageUrl) async {
    final tempFile = await _downloadImage(imageUrl);
    // Route to bunny.net for new uploads
    return uploadImageToCDN(XFile(tempFile.path));
  }

  /// Checks if a URL is from Cloudinary (for backward compatibility)
  static bool isCloudinaryUrl(String url) {
    return url.contains('cloudinary.com') || url.contains('res.cloudinary.com');
  }

  /// Checks if a URL is from bunny.net
  static bool isBunnyNetUrl(String url) {
    return BunnyNetCDNService.isBunnyNetUrl(url);
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
