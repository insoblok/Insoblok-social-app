import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/extensions/extensions.dart';

class LiveStreamProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext c) {
    _context = c;
    notifyListeners();
  }

  CameraController? _cameraController;
  CameraController? get cameraController => _cameraController;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  bool _isLive = false;
  bool get isLive => _isLive;
  set isLive(bool v) {
    _isLive = v;
    notifyListeners();
  }

  String? _sessionId;
  String? get sessionId => _sessionId;

  Future<void> init(BuildContext context) async {
    this.context = context;
    await _setupCamera();
  }

  Future<void> _setupCamera() async {
    try {
      final cameras = await availableCameras();
      CameraDescription selected = cameras.first;
      // Prefer front camera if available for streaming
      for (final cam in cameras) {
        if (cam.lensDirection == CameraLensDirection.front) {
          selected = cam;
          break;
        }
      }
      _cameraController = CameraController(
        selected,
        ResolutionPreset.high,
        enableAudio: true,
      );
      await _cameraController!.initialize();
      _isInitialized = true;
      notifyListeners();
    } catch (e, s) {
      setError(e);
      logger.e(e, stackTrace: s);
    }
  }

  Future<void> toggleLive() async {
    if (!isLive) {
      await _startLive();
    } else {
      await _endLive();
    }
  }

  Future<void> _startLive() async {
    try {
      final uid = AuthHelper.user?.id ?? '';
      final uname = AuthHelper.user?.fullName ?? 'User';
      final avatar = AuthHelper.user?.avatar;
      final liveService = LiveService();
      _sessionId = await liveService.createLiveSession(userId: uid, userName: uname, userAvatar: avatar);
      isLive = true;
    } catch (e, s) {
      setError(e);
      logger.e(e, stackTrace: s);
    }
  }

  Future<void> _endLive() async {
    try {
      final id = _sessionId;
      if (id != null) {
        final liveService = LiveService();
        await liveService.endLiveSession(id);
      }
    } catch (e) {
      setError(e);
    } finally {
      isLive = false;
      _sessionId = null;
    }
  }

  Future<void> endLiveIfActive() async {
    if (isLive) {
      await _endLive();
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }
}


