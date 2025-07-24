import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:googleapis/vision/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:insoblok/locator.dart';

import 'services.dart';

class GoogleVisionService {
  AutoRefreshingAuthClient? _authClient;

  Future<VisionApi> getVisionApi() async {
    if (_authClient != null) return VisionApi(_authClient!);
    final credentials = await _getCredentials();
    _authClient = await clientViaServiceAccount(credentials, [
      VisionApi.cloudVisionScope,
    ], baseClient: http.Client());
    return VisionApi(_authClient!);
  }

  Future<ServiceAccountCredentials> _getCredentials() async {
    // Load your service account credentials from assets
    final jsonString = await rootBundle.loadString(
      'assets/data/insoblokai-news-17063d3f1669.json',
    );
    final json = jsonDecode(jsonString);
    return ServiceAccountCredentials.fromJson(json);
  }

  Future<bool> analyzeImage(String link) async {
    var image = await NetworkHelper.downloadFile(
      link,
      type: 'gallery',
      ext: 'png',
    );

    if (image == null) return false;

    final visionApi = await getVisionApi();

    // Convert image to base64
    final imageBytes = await image.readAsBytes();
    final base64Image = base64Encode(imageBytes);

    // Create request
    final request = BatchAnnotateImagesRequest(
      requests: [
        AnnotateImageRequest(
          image: Image(content: base64Image),
          features: [Feature(type: 'FACE_DETECTION')],
        ),
      ],
    );

    // Send request
    final response = await visionApi.images.annotate(request);

    // Process results
    for (var result in response.responses ?? []) {
      logger.d(result.faceAnnotations);
      if (result.faceAnnotations != null) {
        logger.d('Faces detected: ${result.faceAnnotations.length}');
        return true;
      }
    }
    return false;
  }
}

class GoogleVisionHelper {
  static GoogleVisionService get service => locator<GoogleVisionService>();

  static Future<bool> analyzeImage({required String link}) =>
      service.analyzeImage(link);
}
