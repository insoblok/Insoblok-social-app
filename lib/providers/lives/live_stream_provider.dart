import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/extensions/extensions.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:insoblok/services/stream_video_service.dart';
import 'package:insoblok/services/notification_service.dart';

class LiveStreamProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext c) {
    _context = c;
    notifyListeners();
  }

  CameraController? _cameraController;
  CameraController? get cameraController => _cameraController;
  String? _thumbPath;

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

  String _liveTitle = '';
  String get liveTitle => _liveTitle;
  set liveTitle(String v) {
    _liveTitle = v;
    notifyListeners();
  }

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
      // Log Firebase UID (host)
      logger.d('Firebase UID (host): ${FirebaseAuth.instance.currentUser?.uid}');
      final liveService = LiveService();
      _sessionId = await liveService.createLiveSession(
        userId: uid,
        userName: uname,
        userAvatar: avatar,
        title: _liveTitle.isNotEmpty ? _liveTitle : null,
      );
      // Notify followers that live has started
      if (_sessionId != null) {
        await NotificationService().sendLiveStartNotification(
          fromUserId: uid,
          fromUserName: uname,
          sessionId: _sessionId!,
          title: _liveTitle.isNotEmpty ? _liveTitle : 'Live',
        );
      }

      // Fetch Stream Video user token from backend for later SDK initialization
      try {
        try {
          final t = await FirebaseAppCheck.instance.getToken(true);
          logger.d('AppCheck token (viewer trimmed): ${t?.substring(0, 12)}...');
        } catch (e) {
          logger.w('AppCheck token fetch failed: $e');
        }
        final res = await FirebaseFunctions.instanceFor(app: Firebase.app(), region: 'us-central1').httpsCallable('videoTokenV2').call();
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
          // Capture a quick thumbnail frame before handing off camera to Stream SDK
          try {
            if (_cameraController != null && _cameraController!.value.isInitialized) {
              final shot = await _cameraController!.takePicture();
              _thumbPath = shot.path;
            }
          } catch (_) {}
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
      // Post a simple Story entry about the livestream
      try {
        MediaStoryModel? media;
        if (_thumbPath != null) {
          final uploaded = await CloudinaryCDNService.uploadImageToCDN(XFile(_thumbPath!));
          if ((uploaded.link ?? '').isNotEmpty) {
            media = uploaded;
          }
        }
        final story = StoryModel(
          title: _liveTitle.isNotEmpty ? _liveTitle : 'Live',
          text: _liveTitle.isNotEmpty ? 'Live recording: $_liveTitle' : 'Live recording',
          status: 'public',
          category: 'live',
          medias: media != null ? [media] : null,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await storyService.postStory(story: story);
      } catch (_) {}
      try {
        await StreamVideoService().leave();
      } catch (_) {}
    } catch (e) {
      setError(e);
    } finally {
      isLive = false;
      _sessionId = null;
      _liveTitle = '';
      _thumbPath = null;
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


