import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class BackgroundCameraCapture {
  BackgroundCameraCapture({
    this.maxCaptures = 3, // default: capture 3 frames
    this.stopStreamOnMax = true, // stop stream when max reached
  });

  CameraController? _controller;
  bool _initialized = false;

  bool _paused = false;
  Duration captureInterval = const Duration(seconds: 10);

  Completer<void>? _processingLock;
  DateTime _lastCaptureTime = DateTime.fromMillisecondsSinceEpoch(0);
  int _frameSkipCount = 0;
  static const int _framesToSkip =
      5; // Skip 5 frames for every 1 processed to reduce buffer pressure

  /// Callback when a PNG was written (path can be null on failure).
  void Function(String? path)? onFrame;

  /// Callback when maxCaptures is reached.
  VoidCallback? onMaxReached;

  int maxCaptures;
  bool stopStreamOnMax;

  int _capturesDone = 0;

  bool get isInitialized => _initialized && _controller != null;
  bool get isStreaming => isInitialized && _controller!.value.isStreamingImages;
  bool get isCapturing => !_paused && isStreaming;

  int get capturesDone => _capturesDone;
  int get capturesRemaining =>
      (maxCaptures - _capturesDone).clamp(0, maxCaptures);

  // ---------- INIT / DISPOSE ----------

  Future<void> initialize() async {
    if (_initialized && _controller != null) return;

    _capturesDone = 0;

    final permission = await Permission.camera.request();
    if (!permission.isGranted) {
      throw Exception("Camera permission not granted");
    }

    final cameras = await availableCameras();
    final frontCam = cameras.firstWhere(
      (cam) => cam.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    // IMPORTANT: use YUV on Android, BGRA on iOS
    final formatGroup =
        Platform.isIOS ? ImageFormatGroup.bgra8888 : ImageFormatGroup.yuv420;

    final controller = CameraController(
      frontCam,
      ResolutionPreset.low, // lower res reduces pressure
      enableAudio: false,
      imageFormatGroup: formatGroup,
    );

    controller.addListener(() {
      if (controller.value.hasError) {
        // ignore: avoid_print
        print("Camera error: ${controller.value.errorDescription}");
      }
    });

    await controller.initialize();
    await controller.startImageStream(_processFrame);

    _controller = controller;
    _initialized = true;
    _paused = false;
    // ignore: avoid_print
    print("Camera initialized (image stream).");
  }

  Future<void> dispose() async {
    await stopAndDispose();
  }

  Future<void> stopAndDispose() async {
    try {
      await stopStream();
    } catch (_) {}
    final c = _controller;
    if (c != null) {
      try {
        await c.dispose();
      } catch (_) {}
    }
    _controller = null;
    _initialized = false;
  }

  // ---------- CONTROL APIs ----------

  void pauseCapturing() {
    _paused = true;
  }

  void resumeCapturing() {
    _paused = false;
  }

  Future<void> stopStream() async {
    _paused = true;
    final lock = _processingLock;
    if (lock != null) {
      try {
        await lock.future;
      } catch (_) {}
    }
    final c = _controller;
    if (c != null && c.value.isStreamingImages) {
      await c.stopImageStream();
    }
  }

  Future<void> restartStream() async {
    if (_capturesDone >= maxCaptures) {
      // ignore: avoid_print
      print("Max captures reached; call resetCaptures() to start again.");
      return;
    }
    final c = _controller;
    if (c != null && !c.value.isStreamingImages) {
      await c.startImageStream(_processFrame);
    }
    _paused = false;
  }

  void setCaptureInterval(Duration interval) {
    captureInterval = interval;
  }

  void setMaxCaptures(int n) {
    maxCaptures = n;
  }

  void resetCaptures({int? newMax}) {
    if (newMax != null) maxCaptures = newMax;
    _capturesDone = 0;
    _paused = false;
  }

  // ---------- FRAME PIPELINE ----------

  void _processFrame(CameraImage image) {
    final c = _controller;
    if (c == null) return;

    if (_paused) return;

    // Skip frames to reduce buffer pressure and prevent ImageReader warnings
    _frameSkipCount++;
    if (_frameSkipCount < _framesToSkip) {
      return; // Skip this frame
    }
    _frameSkipCount = 0;

    if (_processingLock != null) return;

    // stop/pause when max reached
    if (_capturesDone >= maxCaptures) {
      if (stopStreamOnMax) {
        stopStream(); // fire and forget
      } else {
        _paused = true;
      }
      onMaxReached?.call();
      return;
    }

    final now = DateTime.now();
    if (now.difference(_lastCaptureTime) < captureInterval) return;
    _lastCaptureTime = now;

    if (!c.value.isInitialized || !c.value.isStreamingImages) return;
    if (image.planes.isEmpty) {
      // ignore: avoid_print
      print("Invalid image plane data");
      return;
    }

    _processingLock = Completer<void>();
    _processFrameAsync(image).whenComplete(() {
      _processingLock?.complete();
      _processingLock = null;
    });
  }

  Future<void> _processFrameAsync(CameraImage image) async {
    try {
      final c = _controller;
      if (c == null) return;

      final pngFile = await capturePngFromCameraImage(image);

      if (pngFile != null) {
        onFrame?.call(pngFile.path);
        _capturesDone++;

        if (_capturesDone >= maxCaptures) {
          if (stopStreamOnMax) {
            await stopStream();
          } else {
            _paused = true;
          }
          onMaxReached?.call();
        }
      } else {
        onFrame?.call(null);
      }
    } catch (e, stack) {
      // ignore: avoid_print
      print("Error in _processFrameAsync: $e\n$stack");
    }
  }

  // ---------- PUBLIC CAPTURE HELPERS ----------

  Future<File?> capturePngFromCameraImage(CameraImage image) async {
    if (!isInitialized) {
      await initialize();
    }

    try {
      // ignore: avoid_print
      print("Capturing image from camera feed...");
      final c = _controller!;
      final pngBytes = await _convertToColorPng(image, c.description);
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/captured_face.png');

      if (file.existsSync()) await file.delete();
      await file.create();
      await file.writeAsBytes(pngBytes);

      return file;
    } catch (e) {
      // ignore: avoid_print
      print("Error capturing PNG: $e");
      return null;
    }
  }

  /// One-off helper: only use when stream is NOT already running.
  Future<File?> capturePngFromStream() async {
    if (!isInitialized) {
      await initialize();
    }

    final c = _controller!;
    if (c.value.isStreamingImages) {
      // ignore: avoid_print
      print("capturePngFromStream aborted: stream already running.");
      return null;
    }

    final completer = Completer<File?>();

    c.startImageStream((CameraImage image) async {
      await c.stopImageStream();

      try {
        final pngBytes = await _convertToColorPng(image, c.description);
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/captured_face.png');

        if (file.existsSync()) await file.delete();
        await file.create();
        await file.writeAsBytes(pngBytes);

        completer.complete(file);
      } catch (e) {
        // ignore: avoid_print
        print("Error capturing PNG from stream: $e");
        completer.complete(null);
      }
    });

    return completer.future;
  }

  // ---------- COLOR CONVERSION (FIXED) ----------

  /// Convert CameraImage → **color** PNG, handling:
  /// - Android: YUV420 (3 planes)
  /// - iOS: BGRA8888 (1 plane)
  Future<Uint8List> _convertToColorPng(
    CameraImage image,
    CameraDescription cameraDescription,
  ) async {
    final int width = image.width;
    final int height = image.height;

    img.Image rgbImage = img.Image(width: width, height: height);

    if (Platform.isIOS && image.planes.length == 1) {
      // iOS BGRA8888
      final Plane plane = image.planes[0];
      final bytes = plane.bytes;
      final bytesPerRow = plane.bytesPerRow; // stride

      for (int y = 0; y < height; y++) {
        final rowStart = y * bytesPerRow;
        for (int x = 0; x < width; x++) {
          final pixelOffset = rowStart + x * 4;
          if (pixelOffset + 3 >= bytes.length) continue;

          final int b = bytes[pixelOffset + 0];
          final int g = bytes[pixelOffset + 1];
          final int r = bytes[pixelOffset + 2];
          // final int a = bytes[pixelOffset + 3]; // alpha, unused

          rgbImage.setPixelRgb(x, y, r, g, b);
        }
      }
    } else if (image.planes.length >= 3) {
      // Android YUV420
      final Plane yPlane = image.planes[0];
      final Plane uPlane = image.planes[1];
      final Plane vPlane = image.planes[2];

      final int yRowStride = yPlane.bytesPerRow;
      final int uvRowStride = uPlane.bytesPerRow;

      for (int y = 0; y < height; y++) {
        final int yRowOffset = y * yRowStride;
        final int uvRowOffset = (y ~/ 2) * uvRowStride;
        for (int x = 0; x < width; x++) {
          final int yIndex = yRowOffset + x;
          final int uvIndex = uvRowOffset + (x ~/ 2);

          if (yIndex >= yPlane.bytes.length ||
              uvIndex >= uPlane.bytes.length ||
              uvIndex >= vPlane.bytes.length) {
            continue;
          }

          final int Y = yPlane.bytes[yIndex];
          final int U = uPlane.bytes[uvIndex];
          final int V = vPlane.bytes[uvIndex];

          // YUV -> RGB (BT.601-ish)
          int r = (Y + 1.370705 * (V - 128)).round();
          int g = (Y - 0.337633 * (U - 128) - 0.698001 * (V - 128)).round();
          int b = (Y + 1.732446 * (U - 128)).round();

          r = r.clamp(0, 255);
          g = g.clamp(0, 255);
          b = b.clamp(0, 255);

          rgbImage.setPixelRgb(x, y, r, g, b);
        }
      }
    } else {
      // Fallback: treat first plane as grayscale → color
      final Plane plane = image.planes[0];
      for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
          final idx = y * plane.bytesPerRow + x;
          if (idx >= plane.bytes.length) continue;
          final int v = plane.bytes[idx];
          rgbImage.setPixelRgb(x, y, v, v, v);
        }
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
}
