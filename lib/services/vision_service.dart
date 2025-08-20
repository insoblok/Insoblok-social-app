import 'dart:convert';
import 'dart:io';
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

  Future<List<AIFaceAnnotation>> analyzeImageUrl(String link) async {

    var image = await NetworkHelper.downloadFile(
      link,
      type: 'gallery',
      ext: 'png',
    );

    if (image == null) return [];

    return await analyzeImageCore(image);
  }

  Future<List<AIFaceAnnotation>> analyzeImageFile(String link) async {

    var image = File(link);

     logger.d('Faces image link in analyzeImageFile: ${image}');

    // if (!image.existsSync()){
      return await analyzeImageCore(image);
    // }
    // return [];
  }

  Future<List<AIFaceAnnotation>> analyzeImageCore(File? image) async {

    logger.d('Face image in analyzeImageCore function: ${image}');

    if (image == null) return [];
    List<AIFaceAnnotation> result = [];
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
          logger.d('underExposedLikelihood: ${annotation.underExposedLikelihood}');
          logger.d('headwearLikelihood: ${annotation.headwearLikelihood}');
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

  Future<List<img.Image>> getFacesFromImageUrl(String imagePath) async {
    // 1. Load the original image
    var image = await NetworkHelper.downloadFile(
      imagePath,
      type: 'gallery',
      ext: 'png',
    );

    if (image == null) return [];
    return await getFacesFromImageCore(image);
  }

  Future<List<img.Image>> getFacesFromLocalImage(String imagePath) async {
    // 1. Load the original image
    var image = File(imagePath);
    if (!image.existsSync()) return [];
    return await getFacesFromImageCore(image);
  }

  Future<List<img.Image>> getFacesFromImageCore(File? image) async {
    // 1. Load the original image
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
    print('The number of faces detected::${faces.length}');

    const paddingFactor = 1.5;

    for (final face in faces) 
    {
      final rect = face.boundingBox;

      // Expand the bounding box
      double newLeft = rect.left - rect.width * paddingFactor / 2;
      double newTop = rect.top - rect.height * paddingFactor / 2;
      double newRight = rect.right + rect.width * paddingFactor / 2;
      double newBottom = rect.bottom + rect.height * paddingFactor / 2;

      // Clamp the values so they stay within image bounds
      int x = newLeft.clamp(0, originalImage.width - 1).toInt();
      int y = newTop.clamp(0, originalImage.height - 1).toInt();
      int width = (newRight - newLeft).clamp(1, originalImage.width - x).toInt();
      int height = (newBottom - newTop).clamp(1, originalImage.height - y).toInt();

      // Crop the expanded rectangle
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
      service.analyzeImageUrl(link);

  static Future<List<AIFaceAnnotation>> analyzeLocalImage({required String link}) =>
      service.analyzeImageFile(link);

  static Future<List<img.Image>> getFacesFromImage({required String link}) =>
      service.getFacesFromLocalImage(link);
}
