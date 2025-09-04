import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:deepar_flutter_plus/deepar_flutter_plus.dart';

class DeepArPlusService with ChangeNotifier {
  DeepArControllerPlus? _controller;      
  bool _engineReady = false;
  bool _viewReady = false;
  bool _recording = false;
  bool _initInProgress = false;
  bool _isFrontCamera = true;
  String? _androidKey;
  String? _iosKey;
  Resolution _resolution = Resolution.medium;
  String? _initialEffect;

  bool get isReady => _engineReady && (_viewReady || !Platform.isIOS);
  bool get isRecording => _recording;
  double get aspectRatio => _controller?.aspectRatio ?? 1.0;
  DeepArControllerPlus get controller => _controller!;

  Future<void> initialize({
    required String androidKey,
    required String iosKey,
    Resolution resolution = Resolution.medium,
    String? initialEffect,
    Duration iosViewTimeout = const Duration(seconds: 10),
  }) async {
    if (_engineReady || _initInProgress) return;   
    _initInProgress = true;

    _androidKey = androidKey;
    _iosKey = iosKey;
    _resolution = resolution;
    _initialEffect = initialEffect;

    _controller ??= DeepArControllerPlus();       
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

  Future<void> switchCamera() async {
    if (!isReady) return;

    final dyn = _controller as dynamic;

    // 1) Try: switchCameraFacing()
    try {
      final r = dyn.switchCameraFacing?.call();
      if (r is Future) await r;
      _isFrontCamera = !_isFrontCamera;
      notifyListeners();
      return;
    } catch (_) {}

    // 2) Try: switchCamera()
    try {
      final r = dyn.switchCamera?.call();
      if (r is Future) await r;
      _isFrontCamera = !_isFrontCamera;
      notifyListeners();
      return;
    } catch (_) {}

    // 3) Try: flipCamera()
    try {
      final r = dyn.flipCamera?.call();
      if (r is Future) await r;
      _isFrontCamera = !_isFrontCamera;
      notifyListeners();
      return;
    } catch (_) {}

    // 4) Fallback: reinitialize engine with toggled facing (if your plugin supports it at init)
    // NOTE: deepar_flutter_plus initialize(...) might not expose facing. If it does (e.g. `cameraFacing:`),
    // pass it here. Otherwise this fallback won’t change the camera.
    await _fallbackReinitializeTogglingFacing();
  }

  Future<void> _fallbackReinitializeTogglingFacing() async {
    if (_androidKey == null || _iosKey == null) return;

    // Tear down
    disposeEngine();

    // Recreate (if your plugin supports passing facing at init, put it here)
    await initialize(
      androidKey: _androidKey!,
      iosKey: _iosKey!,
      resolution: _resolution,
      initialEffect: _initialEffect,
    );

    // We flipped the flag, but without an init-facing param this may still be the same camera.
    _isFrontCamera = !_isFrontCamera;
    notifyListeners();
  }

  void disposeEngine() {
    try {
      _controller?.destroy();
    } finally {
      _controller = null;                
      _engineReady = false;
      _viewReady = false;
      _recording = false;
      _initInProgress = false;
      notifyListeners();
    }
  }

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
