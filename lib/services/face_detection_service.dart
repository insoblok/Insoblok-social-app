import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceDetectionService {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableClassification: true,  // Enables smiling and eye open probabilities
    ),
  );

  // Run face detection asynchronously
  Future<void> detectFaceExpressions(InputImage inputImage) async {
    try {
      final faces = await _faceDetector.processImage(inputImage);

      for (Face face in faces) {
        // If the smiling probability is high, we assume it's a "laughburst"
        if (face.smilingProbability != null && face.smilingProbability! > 0.7) {
          print("Laughburst detected!");
        }

        // Detect "shockface" based on eye and mouth openness
        if (face.leftEyeOpenProbability != null &&
            face.rightEyeOpenProbability != null) {
          if (face.leftEyeOpenProbability! > 0.9 &&
              face.rightEyeOpenProbability! > 0.9) {
            // Check for mouth openness (inferred via mouth contours)
            if (face.contours[FaceContourType.upperLipBottom]?.points.isNotEmpty == true &&
                face.contours[FaceContourType.lowerLipTop]?.points.isNotEmpty == true) {
              print("Shockface detected!");
            }
          }
        }
      }
    } catch (e) {
      print("Error detecting faces: $e");
    }
  }
}