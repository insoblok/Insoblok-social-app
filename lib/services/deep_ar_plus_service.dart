import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:deepar_flutter_plus/deepar_flutter_plus.dart';

class DeepArPlusService with ChangeNotifier {
  DeepArControllerPlus? _controller;      // ← make it nullable (no single final instance)
  bool _engineReady = false;
  bool _viewReady = false;
  bool _recording = false;
  bool _initInProgress = false;

  bool get isReady => _engineReady && (_viewReady || !Platform.isIOS);
  bool get isRecording => _recording;
  double get aspectRatio => _controller?.aspectRatio ?? 1.0;
  DeepArControllerPlus get controller => _controller!;

  /// Initialize once. If already ready (or initializing), this is a no-op.
  Future<void> initialize({
    required String androidKey,
    required String iosKey,
    Resolution resolution = Resolution.medium,
    String? initialEffect,
    Duration iosViewTimeout = const Duration(seconds: 10),
  }) async {
    if (_engineReady || _initInProgress) return;   // ← guard against repeats
    _initInProgress = true;

    _controller ??= DeepArControllerPlus();        // ← create a NEW instance when needed
    try {
      final res = await _controller!.initialize(
        androidLicenseKey: androidKey,
        iosLicenseKey: iosKey,
        resolution: resolution,
      );
      if (!res.success) {
        throw StateError('DeepAR init failed: ${res.message}');
      }
      _engineReady = true;

      if (Platform.isIOS) {
        final sw = Stopwatch()..start();
        while (!_controller!.isInitialized && sw.elapsed < iosViewTimeout) {
          await Future.delayed(const Duration(milliseconds: 100));
        }
        _viewReady = _controller!.isInitialized;
      } else {
        _viewReady = true;
      }

      if (initialEffect?.isNotEmpty == true) {
        await _controller!.switchEffect(initialEffect!);
      }
    } finally {
      _initInProgress = false;
      notifyListeners();
    }
  }

  Future<void> switchEffect(String pathOrUrl) async {
    if (!isReady) return;
    await _controller!.switchEffect(pathOrUrl);
  }

  Future<File?> takePhoto() async {
    if (!isReady) return null;
    return await _controller!.takeScreenshot();
  }

  Future<void> startRecording() async {
    if (!isReady || _recording) return;
    await _controller!.startVideoRecording();
    _recording = true;
    notifyListeners();
  }

  Future<File?> stopRecording() async {
    if (!isReady || !_recording) return null;
    final out = await _controller!.stopVideoRecording();
    _recording = false;
    notifyListeners();
    return out is File ? out : null;
  }

  Future<File?> toggleRecording() async {
    if (_recording) return await stopRecording();
    await startRecording();
    return null;
  }

  /// Clean teardown. Crucially: drop the controller so a fresh one is created next time.
  void disposeEngine() {
    try {
      _controller?.destroy();
    } finally {
      _controller = null;                 // ← KEY: allow a fresh instance on next initialize()
      _engineReady = false;
      _viewReady = false;
      _recording = false;
      _initInProgress = false;
      notifyListeners();
    }
  }

  /// If you intentionally need to re-init (e.g., change resolution), use this.
  Future<void> reinitialize({
    required String androidKey,
    required String iosKey,
    Resolution resolution = Resolution.medium,
    String? initialEffect,
    Duration iosViewTimeout = const Duration(seconds: 10),
  }) async {
    disposeEngine();
    await initialize(
      androidKey: androidKey,
      iosKey: iosKey,
      resolution: resolution,
      initialEffect: initialEffect,
      iosViewTimeout: iosViewTimeout,
    );
  }

  
}
