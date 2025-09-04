import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class BackgroundCameraVideoCapture {
  late CameraController _controller;
  bool _initialized = false;

  /// Callback to notify when video is saved
  void Function(String path)? onVideoRecorded;

  Future<void> initialize() async {
    if (_initialized) return;

    // Ask for permissions
    final camPermission = await Permission.camera.request();
    final micPermission = await Permission.microphone.request();
    if (!camPermission.isGranted || !micPermission.isGranted) {
      throw Exception("Camera or microphone permission not granted");
    }

    // Pick front camera
    final cameras = await availableCameras();
    final frontCam = cameras.firstWhere(
      (cam) => cam.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _controller = CameraController(
      frontCam,
      ResolutionPreset.medium,
      enableAudio: true,
    );

    try {
      await _controller.initialize();
    } catch (e) {
      print("Camera init failed: $e");
    }

    _initialized = true;
    print("Front camera initialized for video recording.");
  }

  /// Record a short video (default 1.5 seconds)
  Future<void> recordShortVideo({double seconds = 1.5}) async {
    if (!_initialized) await initialize();
    if (_controller.value.isRecordingVideo) {
      print("Already recording, skipping.");
      return;
    }

    // Output file
    final dir = await getTemporaryDirectory();
    final filePath = "${dir.path}/short_video.mp4";
    final outFile = File(filePath);
    if (outFile.existsSync()) await outFile.delete();

    // Start recording
    await _controller.startVideoRecording();
    print("Recording started...");

    // Wait for desired duration
    await Future.delayed(Duration(milliseconds: (seconds * 10000).toInt()));

    if (_controller.value.isRecordingVideo) {
      final file = await _controller.stopVideoRecording();
      print("Recording stopped. Saved to: ${file.path}");

      // Move file to desired path (optional)
      await file.saveTo(filePath);
    }
    // Stop and save
    

    // Notify
    if (onVideoRecorded != null) {
      onVideoRecorded!(filePath);
    }
  }

  void dispose() {
    if (_initialized) {
      _controller.dispose();
    }
  }
}
