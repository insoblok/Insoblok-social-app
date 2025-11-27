import 'dart:async';
import 'dart:typed_data';
import 'dart:io' show Platform;

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:insoblok/services/face_detection_service.dart';

class CameraCapture extends StatefulWidget {
  const CameraCapture({super.key});

  @override
  CameraCaptureState createState() => CameraCaptureState();
}

class CameraCaptureState extends State<CameraCapture>
    with WidgetsBindingObserver {
  CameraController? _controller;
  late Future<void> _initializeFuture;

  final FaceDetectionService _faceDetectionService = FaceDetectionService();

  bool _isProcessing = false; // throttle flag
  int _frameCount = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeFuture = _initializeCamera();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final c = _controller;
    if (c == null || !c.value.isInitialized) return;

    if (state == AppLifecycleState.inactive) {
      // App going to background: stop stream / pause
      c.stopImageStream().catchError((_) {});
      c.pausePreview().catchError((_) {});
    } else if (state == AppLifecycleState.resumed) {
      // App back to foreground: resume
      c.resumePreview().catchError((_) {});
      if (!c.value.isStreamingImages) {
        c.startImageStream(_onImage);
      }
    }
  }

  Future<void> _requestPermissions() async {
    final cam = await Permission.camera.request();
    if (!cam.isGranted) {
      throw StateError('Camera permission not granted');
    }
    // Request mic only if you really need it:
    // await Permission.microphone.request();
  }

  Future<void> _initializeCamera() async {
    await _requestPermissions();

    final cameras = await availableCameras();
    final selected = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    final imageFormat =
        Platform.isIOS
            ? ImageFormatGroup
                .bgra8888 // iOS frames are BGRA8888
            : ImageFormatGroup.yuv420; // Android frames are YUV420

    final controller = CameraController(
      selected,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: imageFormat,
    );

    await controller.initialize();
    _controller = controller;

    // Start streaming only after successful init
    await _controller!.startImageStream(_onImage);
  }

  void _onImage(CameraImage image) async {
    final c = _controller;
    if (c == null) return;

    // Simple throttle: process every 3rd frame
    if (_isProcessing || ((_frameCount++ % 3) != 0)) return;
    _isProcessing = true;

    try {
      final input = _buildInputImage(image, c);
      await _faceDetectionService.detectFaceExpressions(input);
    } catch (e, st) {
      debugPrint('Frame processing error: $e\n$st');
    } finally {
      _isProcessing = false;
    }
  }

  /// Build InputImage WITHOUT planeData (compatible with your plugin version).
  InputImage _buildInputImage(CameraImage image, CameraController controller) {
    final bytes = _concatPlanes(image.planes);
    final size = Size(image.width.toDouble(), image.height.toDouble());

    final rotation = _mapRotation(controller.description.sensorOrientation);

    if (Platform.isIOS) {
      // iOS: BGRA8888 (single plane) — bytesPerRow is required
      return InputImage.fromBytes(
        bytes: bytes,
        metadata: InputImageMetadata(
          size: size,
          rotation: rotation,
          format: InputImageFormat.bgra8888,
          bytesPerRow: image.planes.first.bytesPerRow,
        ),
      );
    } else {
      // Android: YUV420 (multi-plane) — your plugin will read planes directly.
      // Do NOT pass planeData here (your version doesn't support it).
      return InputImage.fromBytes(
        bytes: bytes,
        metadata: InputImageMetadata(
          size: size,
          rotation: rotation,
          format: InputImageFormat.yuv420,
          bytesPerRow: image.planes.first.bytesPerRow, // Y stride
        ),
      );
    }
  }

  static Uint8List _concatPlanes(List<Plane> planes) {
    final wb = WriteBuffer();
    for (final p in planes) {
      wb.putUint8List(p.bytes);
    }
    return wb.done().buffer.asUint8List();
  }

  static InputImageRotation _mapRotation(int sensorOrientation) {
    switch (sensorOrientation) {
      case 90:
        return InputImageRotation.rotation90deg;
      case 180:
        return InputImageRotation.rotation180deg;
      case 270:
        return InputImageRotation.rotation270deg;
      case 0:
      default:
        return InputImageRotation.rotation0deg;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Vybecam")),
      body: FutureBuilder<void>(
        future: _initializeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              _controller != null) {
            return CameraPreview(
              _controller!,
            ); // Color preview from platform texture
          }
          if (snapshot.hasError) {
            return Center(child: Text('Camera error: ${snapshot.error}'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    final c = _controller;
    _controller = null;
    if (c != null) {
      c.stopImageStream().catchError((_) {});
      c.dispose();
    }
    super.dispose();
  }
}
