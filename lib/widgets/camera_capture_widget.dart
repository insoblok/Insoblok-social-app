import 'package:camera/camera.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:insoblok/services/face_detection_service.dart';
import 'package:flutter/foundation.dart'; // For compute

class CameraCapture extends StatefulWidget {
  @override
  CameraCaptureState createState() => CameraCaptureState();
}

class CameraCaptureState extends State<CameraCapture> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  bool isDetectingFaces = false;
  final FaceDetectionService _faceDetectionService = FaceDetectionService();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  // Request camera permissions
  Future<void> _requestPermissions() async {
    await Permission.camera.request();
    await Permission.microphone.request();
  }

  // Initialize the camera
  void _initializeCamera() async {
    await _requestPermissions();

    final cameras = await availableCameras();
    final camera = cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.front);

    _cameraController = CameraController(camera, ResolutionPreset.high);
    _initializeControllerFuture = _cameraController.initialize();

    // Start the frame-by-frame processing
    _startFrameProcessing();
  }

  // Start frame processing for face detection (offload to background using compute)
  void _startFrameProcessing() {
    _cameraController.startImageStream((CameraImage image) async {
      if (!isDetectingFaces) {
        isDetectingFaces = true;
        // Offload the image processing and face detection to an isolate
        await compute(_processImageInBackground, image);
        isDetectingFaces = false;
      }
    });
  }

  // Image processing and face detection (background task)
  static Future<void> _processImageInBackground(CameraImage image) async {
    try {
      final InputImage inputImage = await _convertCameraImageToInputImage(image);
      final faceDetectionService = FaceDetectionService();
      await faceDetectionService.detectFaceExpressions(inputImage);
    } catch (e) {
      print("Error processing image in background: $e");
    }
  }

  // Convert CameraImage to InputImage for ML Kit
  static Future<InputImage> _convertCameraImageToInputImage(CameraImage image) async {
    final WriteBuffer allBytes = WriteBuffer();
    for (Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final Uint8List bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize = Size(image.width.toDouble(), image.height.toDouble());

    return InputImage.fromBytes(bytes: bytes, metadata: InputImageMetadata(
      size: imageSize,
      rotation: InputImageRotation.rotation0deg,
      format: InputImageFormat.yuv420,
      bytesPerRow: image.planes[0].bytesPerRow,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Vybecam")),
      body: Column(
        children: [
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return CameraPreview(_cameraController);
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }  
}
