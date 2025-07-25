import 'dart:convert';

import 'package:flutter/services.dart';

import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:googleapis/vision/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

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

  Future<List<img.Image>> getFacesFromImage(String imagePath) async {
    // 1. Load the original image
    var image = await NetworkHelper.downloadFile(
      imagePath,
      type: 'gallery',
      ext: 'png',
    );

    if (image == null) return [];
    final originalImageBytes = await image.readAsBytes();
    final originalImage = img.decodeImage(originalImageBytes)!;

    // 2. Initialize face detector
    final faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableLandmarks: true,
        enableContours: true,
        enableClassification: true,
      ),
    );

    // 3. Create input image for detection
    final inputImage = InputImage.fromFile(image);

    // 4. Detect faces
    final faces = await faceDetector.processImage(inputImage);

    // 5. Extract each face as separate image
    final List<img.Image> faceImages = [];

    for (final face in faces) {
      final rect = face.boundingBox;

      // Ensure the rectangle is within image bounds
      final x = rect.left.clamp(0, originalImage.width - 1).toInt();
      final y = rect.top.clamp(0, originalImage.height - 1).toInt();
      final width = rect.width.clamp(1, originalImage.width - x).toInt();
      final height = rect.height.clamp(1, originalImage.height - y).toInt();

      // Crop the face from original image
      final faceImage = img.copyCrop(
        originalImage,
        x: x,
        y: y,
        width: width,
        height: height,
      );

      faceImages.add(faceImage);
    }

    // 6. Close detector
    await faceDetector.close();

    return faceImages;
  }
}

class GoogleVisionHelper {
  static GoogleVisionService get service => locator<GoogleVisionService>();

  static Future<bool> analyzeImage({required String link}) =>
      service.analyzeImage(link);

  static Future<List<img.Image>> getFacesFromImage({required String link}) =>
      service.getFacesFromImage(link);
}
