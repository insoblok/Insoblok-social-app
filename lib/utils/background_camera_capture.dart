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
    this.maxCaptures = 3,          // ✨ default: capture 3 frames
    this.stopStreamOnMax = true,   // stop stream when max reached (set false to just pause)
  });

  CameraController? _controller;
  bool _initialized = false;

  // Soft pause and interval
  bool _paused = false;
  Duration captureInterval = const Duration(seconds: 10);

  Completer<void>? _processingLock;
  DateTime _lastCaptureTime = DateTime.fromMillisecondsSinceEpoch(0);

  /// Callback when a PNG was written (path can be null on failure).
  void Function(String? path)? onFrame;

  /// Callback when maxCaptures is reached.
  VoidCallback? onMaxReached;

  /// ✨ Capture limit
  int maxCaptures;
  bool stopStreamOnMax;

  int _capturesDone = 0;

  bool get isInitialized => _initialized && _controller != null;
  bool get isStreaming => isInitialized && _controller!.value.isStreamingImages;
  bool get isCapturing => !_paused && isStreaming;

  int get capturesDone => _capturesDone;
  int get capturesRemaining => (maxCaptures - _capturesDone).clamp(0, maxCaptures);

  Future<void> initialize() async {
    if (_initialized && _controller != null) return;

    // reset counters on new init
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

    final controller = CameraController(
      frontCam,
      ResolutionPreset.low, // lower res reduces pressure
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.yuv420,
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

  // ---------- Control APIs ----------

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
      try { await lock.future; } catch (_) {}
    }
    final c = _controller;
    if (c != null && c.value.isStreamingImages) {
      await c.stopImageStream();
    }
  }

  Future<void> restartStream() async {
    // If we already reached max, don't restart unless user resets.
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

  Future<void> stopAndDispose() async {
    try { await stopStream(); } catch (_) {}
    final c = _controller;
    if (c != null) {
      try { await c.dispose(); } catch (_) {}
    }
    _controller = null;
    _initialized = false;
  }

  void setCaptureInterval(Duration interval) {
    captureInterval = interval;
  }

  /// ✨ Change the limit at runtime (does NOT reset current count)
  void setMaxCaptures(int n) {
    maxCaptures = n;
  }

  /// ✨ Reset the counter (optionally change max) so capturing can start again
  void resetCaptures({int? newMax}) {
    if (newMax != null) maxCaptures = newMax;
    _capturesDone = 0;
    _paused = false;
  }

  // ---------- Frame Pipeline ----------

  void _processFrame(CameraImage image) {
    final c = _controller;
    if (c == null) return;

    if (_paused) return;
    if (_processingLock != null) return;

    // ✨ stop/pause when max reached
    if (_capturesDone >= maxCaptures) {
      if (stopStreamOnMax) {
        // hard stop
        stopStream(); // fire and forget
      } else {
        // soft pause
        _paused = true;
      }
      onMaxReached?.call();
      return;
    }

    final now = DateTime.now();
    if (now.difference(_lastCaptureTime) < captureInterval) return;
    _lastCaptureTime = now;

    if (!c.value.isInitialized || !c.value.isStreamingImages) return;
    if (image.planes.length < 3) {
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

      // Only count successful saves
      if (pngFile != null) {
        onFrame?.call(pngFile.path);
        _capturesDone++;

        // ✨ reached limit? stop/pause and notify
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

  Future<File?> capturePngFromCameraImage(CameraImage image) async {
    if (!isInitialized) {
      await initialize();
    }

    try {
      // ignore: avoid_print
      print("Capturing image from camera feed...");
      final c = _controller!;
      final pngBytes = await _convertToRgbPng(image, c.description);
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

    final img.Image imgData =
        img.Image(width: width, height: height, numChannels: 1);

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final pixel = plane.bytes[y * plane.bytesPerRow + x];
        imgData.setPixel(x, y, img.ColorUint8.rgb(pixel, pixel, pixel));
      }
    }

    return Uint8List.fromList(img.encodePng(imgData));
  }

  Future<Uint8List> _convertToRgbPng(
      CameraImage image, CameraDescription cameraDescription) async {
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

  Future<void> dispose() async {
    await stopAndDispose();
  }
}
