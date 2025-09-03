import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class BackgroundCameraVideoCapture {
  CameraController? _controller;
  bool _initialized = false;

  /// Callback to notify when video is saved
  void Function(String path)? onVideoRecorded;

  bool get isInitialized => _initialized && _controller != null;
  bool get isRecording => _controller?.value.isRecordingVideo == true;

  Future<void> initialize() async {
    if (_initialized && _controller != null) return;

    final camPermission = await Permission.camera.request();
    final micPermission = await Permission.microphone.request();
    if (!camPermission.isGranted || !micPermission.isGranted) {
      throw Exception("Camera or microphone permission not granted");
    }

    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      throw Exception("No cameras available on this device");
    }
    final frontCam = cameras.firstWhere(
      (cam) => cam.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    final controller = CameraController(
      frontCam,
      // Lower to reduce codec buffer pressure
      ResolutionPreset.low,
      enableAudio: true,
    );

    try {
      await controller.initialize();
    } catch (e) {
      try { await controller.dispose(); } catch (_) {}
      rethrow;
    }

    controller.addListener(() {
      if (controller.value.hasError) {
        // ignore: avoid_print
        print("Video Camera error: ${controller.value.errorDescription}");
      }
    });

    _controller = controller;
    _initialized = true;
    // ignore: avoid_print
    print("Front camera initialized for video recording.");
  }

  /// Record a short video (default 1.5 seconds)
  Future<void> recordShortVideo({double seconds = 1.5}) async {
    if (!isInitialized) await initialize();
    final c = _controller!;
    if (c.value.isRecordingVideo) {
      // ignore: avoid_print
      print("Already recording, skipping.");
      return;
    }

    await c.startVideoRecording();
    // ignore: avoid_print
    print("Recording started...");

    final ms = (seconds * 1000).round();
    await Future.delayed(Duration(milliseconds: ms));

    String? outPath;
    if (c.value.isRecordingVideo) {
      final xfile = await c.stopVideoRecording();

      final dir = await getTemporaryDirectory();
      final ext = Platform.isIOS ? 'mov' : 'mp4';
      final ts = DateTime.now().millisecondsSinceEpoch;
      outPath = "${dir.path}/short_video_$ts.$ext";

      await xfile.saveTo(outPath);
      // ignore: avoid_print
      print("Recording stopped. Saved to: $outPath");
    }

    if (outPath != null && onVideoRecorded != null) {
      onVideoRecorded!(outPath);
    }
  }

  /// Fully release the camera so the image stream controller can grab it again.
  Future<void> stopAndDispose() async {
    final c = _controller;
    if (c != null) {
      try {
        if (c.value.isRecordingVideo) {
          await c.stopVideoRecording();
        }
      } catch (_) {}
      try {
        await c.dispose();
      } catch (_) {}
    }
    _controller = null;
    _initialized = false;
  }

  void dispose() {
    // Fire-and-forget
    stopAndDispose();
  }
}
