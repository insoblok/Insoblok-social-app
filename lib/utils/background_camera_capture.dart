import 'dart:io';
import 'dart:typed_data';
import 'dart:async';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class BackgroundCameraCapture {
  late CameraController _controller;
  bool _initialized = false;
  bool _isProcessing = false;
  DateTime _lastCaptureTime = DateTime.fromMillisecondsSinceEpoch(0);

  // Callback function to pass captured image to google vision api
  void Function(String? path)? onFrame;

  Future<void> initialize() async {
    //if(_initialized) return;
    await Permission.camera.request();

    final cameras = await availableCameras();
    final frontCam = cameras.firstWhere(
      (cam) => cam.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first
    );

    _controller = CameraController(frontCam, ResolutionPreset.medium, enableAudio: false);
    await _controller.initialize();

    await _controller.startImageStream(_processFrame);
    _initialized = true;
  }

  void _processFrame(CameraImage image) async {
    if (_isProcessing) return;

    // Throttle: Only allow once per second
    if (DateTime.now().difference(_lastCaptureTime).inMilliseconds < 20000) return;

    _isProcessing = true;
    _lastCaptureTime = DateTime.now();

    try {
      final pngFile = await capturePngFromCameraImage(image);
      onFrame?.call(pngFile?.path);
    } catch (e) {
      print("Error processing frame: $e");
    } finally {
      _isProcessing = false;
    }
  }

  Future<File?> capturePngFromCameraImage(CameraImage image) async {
    if (!_initialized) await initialize();

    final completer = Completer<File?>();

      try {
        print("Trying to capture image from camera feed");
        final pngBytes = await _convertToRgbPng(image, _controller.description);
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/captured_face.png');
        await file.writeAsBytes(pngBytes);
        completer.complete(file);
      } catch (e) {
        print("Error capturing PNG: $e");
        completer.complete(null);
      }
    

    return completer.future;
  }

  Future<File?> capturePngFromStream() async {
    if (!_initialized) await initialize();

    final completer = Completer<File?>();

    _controller.startImageStream((CameraImage image) async {
      _controller.stopImageStream(); // stop after one frame

      try {
        final pngBytes = await _convertToPng(image);
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/captured_face.png');
        await file.writeAsBytes(pngBytes);
        completer.complete(file);
      } catch (e) {
        print("Error capturing PNG: $e");
        completer.complete(null);
      }
    });

    return completer.future;
  }

  Future<Uint8List> _convertToPng(CameraImage image) async {
    final int width = image.width;
    final int height = image.height;

    final plane = image.planes[0];
    final imgData = img.Image(width:width, height:height, numChannels: 1);

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final pixel = plane.bytes[y * plane.bytesPerRow + x];
        imgData.setPixel(x, y, img.ColorUint8.rgb(pixel, pixel, pixel));
      }
    }

    return Uint8List.fromList(img.encodePng(imgData));
  }

/// Converts YUV420 [CameraImage] to color PNG as [Uint8List]
Future<Uint8List> _convertToRgbPng(
  CameraImage image,
  CameraDescription cameraDescription,) async {
  final int width = image.width;
  final int height = image.height;

  final Plane yPlane = image.planes[0];
  final Plane uPlane = image.planes[1];
  final Plane vPlane = image.planes[2];

  final img.Image rgbImage = img.Image(width:width, height:height);

  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      final int uvIndex = (y ~/ 2) * uPlane.bytesPerRow + (x ~/ 2);
      final int yIndex = y * yPlane.bytesPerRow + x;

      final int Y = yPlane.bytes[yIndex];
      final int U = uPlane.bytes[uvIndex];
      final int V = vPlane.bytes[uvIndex];

      // Convert YUV -> RGB (based on Android YUV420 formula)
      final int R = (Y + 1.370705 * (V - 128)).clamp(0, 255).toInt();
      final int G = (Y - 0.337633 * (U - 128) - 0.698001 * (V - 128)).clamp(0, 255).toInt();
      final int B = (Y + 1.732446 * (U - 128)).clamp(0, 255).toInt();

      rgbImage.setPixelRgb(x, y, R, G, B);
    }
  }

  
  // 🔁 Rotate the image based on sensor orientation
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
    case 0:
    default:
      // No rotation needed
      break;
  }

  // 🪞 Flip horizontally if front-facing camera
  if (cameraDescription.lensDirection == CameraLensDirection.front) {
    rotatedImage = img.flipHorizontal(rotatedImage);
  }


  return Uint8List.fromList(img.encodePng(rotatedImage));
}

  void dispose() {
    _controller.dispose();
  }
}