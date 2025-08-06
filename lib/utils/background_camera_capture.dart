import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class BackgroundCameraCapture {
  late CameraController _controller;
  bool _initialized = false;
  Completer<void>? _processingLock;
  DateTime _lastCaptureTime = DateTime.fromMillisecondsSinceEpoch(0);

  /// Callback function to pass captured image to Google Vision API or other consumers.
  void Function(String? path)? onFrame;

  Future<void> initialize() async {
    if (_initialized) return;

    final permission = await Permission.camera.request();
    if (!permission.isGranted) {
      throw Exception("Camera permission not granted");
    }

    final cameras = await availableCameras();
    final frontCam = cameras.firstWhere(
      (cam) => cam.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _controller = CameraController(
      frontCam,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    _controller.addListener(() {
      if (_controller.value.hasError) {
        print("Camera error: ${_controller.value.errorDescription}");
      }
    });

    await _controller.initialize();
    await _controller.startImageStream(_processFrame);

    _initialized = true;
    print("Camera initialized.");
  }

  void _processFrame(CameraImage image) {
    // Skip if already processing
    if (_processingLock != null) return;

    // Skip if not enough time has passed
    final now = DateTime.now();
    if (now.difference(_lastCaptureTime).inMilliseconds < 2000) return;
    _lastCaptureTime = now;

    // Ensure camera is ready
    if (!_controller.value.isInitialized || !_controller.value.isStreamingImages) return;

    // Validate image planes
    if (image.planes.length < 3) {
      print("Invalid image plane data");
      return;
    }

    _processingLock = Completer();
    _processFrameAsync(image).whenComplete(() {
      _processingLock?.complete();
      _processingLock = null;
    });
  }

  Future<void> _processFrameAsync(CameraImage image) async {
    try {
      final pngFile = await capturePngFromCameraImage(image);
      onFrame?.call(pngFile?.path);
    } catch (e, stack) {
      print("Error in _processFrameAsync: $e\n$stack");
    }
  }

  Future<File?> capturePngFromCameraImage(CameraImage image) async {
    if (!_initialized) await initialize();

    try {
      print("Capturing image from camera feed...");
      final pngBytes = await _convertToRgbPng(image, _controller.description);
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/captured_face.png');

      if (file.existsSync()) await file.delete();
      await file.create();
      await file.writeAsBytes(pngBytes);

      return file;
    } catch (e) {
      print("Error capturing PNG: $e");
      return null;
    }
  }

  Future<File?> capturePngFromStream() async {
    if (!_initialized) await initialize();

    final completer = Completer<File?>();

    _controller.startImageStream((CameraImage image) async {
      _controller.stopImageStream();

      try {
        final pngBytes = await _convertToPng(image);
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/captured_face.png');

        if (file.existsSync()) await file.delete();
        await file.create();
        await file.writeAsBytes(pngBytes);

        completer.complete(file);
      } catch (e) {
        print("Error capturing PNG from stream: $e");
        completer.complete(null);
      }
    });

    return completer.future;
  }

  Future<Uint8List> _convertToPng(CameraImage image) async {
    final int width = image.width;
    final int height = image.height;
    final plane = image.planes[0];

    final img.Image imgData = img.Image(width: width, height: height, numChannels: 1);

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final pixel = plane.bytes[y * plane.bytesPerRow + x];
        imgData.setPixel(x, y, img.ColorUint8.rgb(pixel, pixel, pixel));
      }
    }

    return Uint8List.fromList(img.encodePng(imgData));
  }

  Future<Uint8List> _convertToRgbPng(CameraImage image, CameraDescription cameraDescription) async {
    final int width = image.width;
    final int height = image.height;

    final Plane yPlane = image.planes[0];
    final Plane uPlane = image.planes[1];
    final Plane vPlane = image.planes[2];

    final img.Image rgbImage = img.Image(width: width, height: height);

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final int uvIndex = (y ~/ 2) * uPlane.bytesPerRow + (x ~/ 2);
        final int yIndex = y * yPlane.bytesPerRow + x;

        final int Y = yPlane.bytes[yIndex];
        final int U = uPlane.bytes[uvIndex];
        final int V = vPlane.bytes[uvIndex];

        final int R = (Y + 1.370705 * (V - 128)).clamp(0, 255).toInt();
        final int G = (Y - 0.337633 * (U - 128) - 0.698001 * (V - 128)).clamp(0, 255).toInt();
        final int B = (Y + 1.732446 * (U - 128)).clamp(0, 255).toInt();

        rgbImage.setPixelRgb(x, y, R, G, B);
      }
    }

    // Rotate image based on sensor orientation
    img.Image rotatedImage = rgbImage;
    switch (cameraDescription.sensorOrientation) {
      case 90:
        rotatedImage = img.copyRotate(rgbImage, angle: 90);
        break;
      case 180:
        rotatedImage = img.copyRotate(rgbImage, angle: 180);
        break;
      case 270:
        rotatedImage = img.copyRotate(rgbImage, angle: -90);
        break;
      default:
        break;
    }

    // Flip horizontally if using front camera
    if (cameraDescription.lensDirection == CameraLensDirection.front) {
      rotatedImage = img.flipHorizontal(rotatedImage);
    }

    return Uint8List.fromList(img.encodePng(rotatedImage));
  }

  void dispose() {
    _controller.dispose();
  }
}
