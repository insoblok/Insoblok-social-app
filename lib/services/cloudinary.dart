import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cloudinary_flutter/image/cld_image.dart';
import 'package:cloudinary_flutter/cloudinary_context.dart';
import 'package:cloudinary_flutter/cloudinary_object.dart';

class CloudinaryService {
  final String cloudName = "YOUR_CLOUD_NAME";
  final String uploadPreset = "YOUR_UNSIGNED_UPLOAD_PRESET"; // set in Cloudinary dashboard

  Future<String?> uploadImage(File imageFile) async {
    final uri = Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");

    var request = http.MultipartRequest("POST", uri)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    var response = await request.send();

    if (response.statusCode == 200) {
      final res = await http.Response.fromStream(response);
      final data = res.body;
      print("Uploaded: $data");
      return data; // contains URL + public_id
    } else {
      print("Upload failed: ${response.statusCode}");
      return null;
    }
  }
}
