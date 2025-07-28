import 'dart:convert';

import 'package:flutter/services.dart';

import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:googleapis/vision/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

import 'package:insoblok/locator.dart';
import 'package:insoblok/utils/utils.dart';

import 'services.dart';

class AIFaceAnnotation {
  final String title;
  final String icon;
  final String value;

  AIFaceAnnotation({
    required this.title,
    required this.icon,
    required this.value,
  });

  String get desc {
    if (value == 'VERY_UNLIKELY') return '20%';
    if (value == 'UNLIKELY') return '40%';
    if (value == 'POSSIBLE') return '60%';
    if (value == 'LIKELY') return '80%';
    if (value == 'VERY_LIKELY') return '100%';
    return '---';
  }
}

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

  Future<List<AIFaceAnnotation>> analyzeImage(String link) async {
    List<AIFaceAnnotation> result = [];
    var image = await NetworkHelper.downloadFile(
      link,
      type: 'gallery',
      ext: 'png',
    );

    if (image == null) return [];

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
    for (AnnotateImageResponse result in response.responses ?? []) {
      logger.d(result.faceAnnotations);
      if (result.faceAnnotations != null) {
        logger.d('Faces detected: ${result.faceAnnotations?.length}');
        if ((result.faceAnnotations ?? []).isNotEmpty) {
          var annotation = result.faceAnnotations!.first;

          return [
            if (annotation.angerLikelihood != null)
              AIFaceAnnotation(
                title: 'Angry',
                icon: AIImages.icFaceAngry,
                value: annotation.angerLikelihood!,
              ),
            if (annotation.joyLikelihood != null)
              AIFaceAnnotation(
                title: 'Joy',
                icon: AIImages.icFaceLaugh,
                value: annotation.joyLikelihood!,
              ),
            if (annotation.sorrowLikelihood != null)
              AIFaceAnnotation(
                title: 'Sad',
                icon: AIImages.icFaceSad,
                value: annotation.sorrowLikelihood!,
              ),
            if (annotation.surpriseLikelihood != null)
              AIFaceAnnotation(
                title: 'Shock',
                icon: AIImages.icFaceShock,
                value: annotation.surpriseLikelihood!,
              ),
          ];
        }
      }
    }
    return result;
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
      logger.d(face.smilingProbability);

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

  static Future<List<AIFaceAnnotation>> analyzeImage({required String link}) =>
      service.analyzeImage(link);

  static Future<List<img.Image>> getFacesFromImage({required String link}) =>
      service.getFacesFromImage(link);
}
