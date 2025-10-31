import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/extensions/extensions.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:insoblok/services/stream_video_service.dart';

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

  // Prepared fields for Stream Video client hookup
  String? _streamApiKey;
  String? _streamUserToken;
  String? _streamUserId;
  String? get streamApiKey => _streamApiKey;
  String? get streamUserToken => _streamUserToken;
  String? get streamUserId => _streamUserId;

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

      // Fetch Stream Video user token from backend for later SDK initialization
      try {
        final res = await FirebaseFunctions.instance.httpsCallable('videoTokenV2').call();
        final data = (res.data as Map).cast<String, dynamic>();
        _streamApiKey = data['apiKey'] as String?;
        _streamUserToken = data['token'] as String?;
        _streamUserId = data['userId'] as String?;
      } catch (e) {
        // Token is optional until Stream SDK hookup is completed
        logger.w('Failed to fetch Stream token: $e');
      }

      // Join the Stream livestream as host if we have creds and callId
      try {
        final callId = _sessionId != null ? await liveService.getCallId(_sessionId!) : null;
        if (_streamApiKey != null && _streamUserToken != null && _streamUserId != null && callId != null) {
          // Release local CameraController before Stream takes ownership of camera
          await _cameraController?.dispose();
          _cameraController = null;
          _isInitialized = false;

          final stream = StreamVideoService();
          await stream.connect(apiKey: _streamApiKey!, userId: _streamUserId!, userName: uname, userToken: _streamUserToken!);
          await stream.joinLivestream(callId: callId, asHost: true);
        }
      } catch (e, s) {
        logger.w('Stream join failed: $e', stackTrace: s);
      }
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
      try {
        await StreamVideoService().leave();
      } catch (_) {}
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


