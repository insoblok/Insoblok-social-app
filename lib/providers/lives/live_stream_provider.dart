import 'dart:io';

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
  String? _videoPath;
  bool _isRecording = false;

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

  bool _isToggling = false;
  bool get isToggling => _isToggling;

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
    // Prevent multiple simultaneous toggles
    if (_isToggling) {
      logger.w('⚠️ Toggle already in progress, ignoring request');
      return;
    }

    _isToggling = true;
    notifyListeners();

    try {
      if (!isLive) {
        // Optimistic update: set state immediately for instant UI feedback
        isLive = true;
        notifyListeners();
        // Then run the actual start process
        await _startLive();
        // Reset toggling after start completes
        _isToggling = false;
        notifyListeners();
      } else {
        // Optimistic update: set state immediately for instant UI feedback
        isLive = false;
        notifyListeners();
        // Run end process - this will handle its own toggling state
        await _endLive();
        // _endLive() resets _isToggling early, but ensure it's reset here too
        _isToggling = false;
        notifyListeners();
      }
    } catch (e, stackTrace) {
      logger.e('❌ Error in toggleLive: $e', stackTrace: stackTrace);
      // Ensure toggling is reset on error
      _isToggling = false;
      notifyListeners();
      rethrow;
    } finally {
      // Always ensure toggling is reset (safety net)
      if (_isToggling) {
        logger.w('⚠️ Resetting _isToggling in finally block (safety net)');
        _isToggling = false;
        notifyListeners();
      }
    }
  }

  Future<void> _startLive() async {
    try {
      final uid = AuthHelper.user?.id ?? '';
      final uname = AuthHelper.user?.fullName ?? 'User';
      final avatar = AuthHelper.user?.avatar;
      // Log Firebase UID (host)
      logger.d(
        'Firebase UID (host): ${FirebaseAuth.instance.currentUser?.uid}',
      );
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
          logger.d(
            'AppCheck token (viewer trimmed): ${t?.substring(0, 12)}...',
          );
        } catch (e) {
          logger.w('AppCheck token fetch failed: $e');
        }
        final res =
            await FirebaseFunctions.instanceFor(
              app: Firebase.app(),
              region: 'us-central1',
            ).httpsCallable('videoTokenV2').call();
        final data = (res.data as Map).cast<String, dynamic>();
        _streamApiKey = data['apiKey'] as String?;
        _streamUserToken = data['token'] as String?;
        _streamUserId = data['userId'] as String?;
      } catch (e) {
        // Token is optional until Stream SDK hookup is completed
        logger.w('Failed to fetch Stream token: $e');
      }

      // Start recording video before joining Stream
      // We record the camera feed before Stream SDK potentially takes exclusive control
      try {
        if (_cameraController != null &&
            _cameraController!.value.isInitialized) {
          if (!_cameraController!.value.isRecordingVideo) {
            await _cameraController!.startVideoRecording();
            _isRecording = true;
            logger.d('✅ Started video recording for live stream');
            logger.d(
              'Recording state: ${_cameraController!.value.isRecordingVideo}',
            );
          } else {
            logger.w('Video recording already in progress');
            _isRecording = true;
          }
        } else {
          logger.w('Cannot start recording: camera controller not ready');
        }
      } catch (e, stackTrace) {
        logger.e(
          '❌ Failed to start video recording: $e',
          stackTrace: stackTrace,
        );
        _isRecording = false;
      }

      // Join the Stream livestream as host if we have creds and callId
      try {
        final callId =
            _sessionId != null
                ? await liveService.getCallId(_sessionId!)
                : null;
        if (_streamApiKey != null &&
            _streamUserToken != null &&
            _streamUserId != null &&
            callId != null) {
          // Capture a quick thumbnail frame
          try {
            if (_cameraController != null &&
                _cameraController!.value.isInitialized) {
              final shot = await _cameraController!.takePicture();
              _thumbPath = shot.path;
            }
          } catch (_) {}

          // Try to keep camera controller for recording
          // If Stream SDK needs exclusive access, it will handle that
          // We'll try to keep recording as long as possible

          final stream = StreamVideoService();
          await stream.connect(
            apiKey: _streamApiKey!,
            userId: _streamUserId!,
            userName: uname,
            userToken: _streamUserToken!,
          );
          await stream.joinLivestream(callId: callId, asHost: true);

          // Note: Stream SDK might take camera control
          // If recording fails after this, we'll still have what we recorded before
        } else {
          // If Stream SDK is not available, keep recording with local camera
          logger.d('Stream SDK not available, continuing with local recording');
        }
      } catch (e, s) {
        logger.w('Stream join failed: $e', stackTrace: s);
        // Continue with local recording even if Stream fails
      }
      // State already updated optimistically, just ensure it's still true
      if (!isLive) {
        isLive = true;
        notifyListeners();
      }
    } catch (e, s) {
      setError(e);
      logger.e('Error starting live: $e', stackTrace: s);
      // Revert optimistic update on error
      isLive = false;
      _isRecording = false;
      notifyListeners();
      AIHelpers.showToast(msg: 'Failed to start live stream: ${e.toString()}');
    }
  }

  Future<void> _endLive() async {
    try {
      // Stop video recording first (before disposing camera)
      logger.d(
        'Attempting to stop video recording. _isRecording: $_isRecording',
      );
      if (_isRecording) {
        try {
          if (_cameraController != null &&
              _cameraController!.value.isInitialized) {
            logger.d('Camera controller is initialized');
            logger.d(
              'Is recording video: ${_cameraController!.value.isRecordingVideo}',
            );

            if (_cameraController!.value.isRecordingVideo) {
              logger.d('Stopping video recording...');
              final videoFile = await _cameraController!.stopVideoRecording();
              _videoPath = videoFile.path;
              logger.d('✅ Stopped video recording: $_videoPath');

              // Verify video file exists and has content
              final file = File(_videoPath!);
              if (await file.exists()) {
                final fileSize = await file.length();
                logger.d('✅ Video file exists. Size: $fileSize bytes');
                if (fileSize == 0) {
                  logger.w('⚠️ Video file is empty!');
                  _videoPath = null; // Don't use empty file
                } else {
                  logger.d('✅ Video file is valid and ready for upload');
                }
              } else {
                logger.e('❌ Video file does not exist at path: $_videoPath');
                _videoPath = null;
              }
            } else {
              logger.w(
                '⚠️ Camera was not recording video (state: ${_cameraController!.value.isRecordingVideo})',
              );
            }
          } else {
            logger.w('⚠️ Camera controller not initialized or null');
            logger.d('Controller null: ${_cameraController == null}');
            if (_cameraController != null) {
              logger.d(
                'Controller initialized: ${_cameraController!.value.isInitialized}',
              );
            }
          }
          _isRecording = false;
        } catch (e, stackTrace) {
          logger.e(
            '❌ Error stopping video recording: $e',
            stackTrace: stackTrace,
          );
          _isRecording = false;
          _videoPath = null;
        }
      } else {
        logger.w('⚠️ Video recording was not active (_isRecording = false)');
      }

      logger.d('Final video path after stopping: $_videoPath');

      final id = _sessionId;
      if (id != null) {
        final liveService = LiveService();
        await liveService.endLiveSession(id);
      }

      // Save paths before cleanup (they'll be used in background posting)
      final videoPathToPost = _videoPath;
      final thumbPathToPost = _thumbPath;
      final titleToPost = _liveTitle;

      logger.d('📝 Paths saved for posting:');
      logger.d('  Video: $videoPathToPost');
      logger.d('  Thumbnail: $thumbPathToPost');
      logger.d('  Title: $titleToPost');

      // Reset toggling state early so button becomes usable again
      // The video upload and story posting will continue in background
      _isToggling = false;
      notifyListeners();

      logger.d('✅ Critical operations completed. Ready for navigation.');

      // Post Story with video from live stream (runs in background)
      // Pass paths as parameters so they're not cleared by finally block
      if (videoPathToPost != null || thumbPathToPost != null) {
        logger.d('🚀 Starting background video posting...');
        // Post in background - don't await
        _postLiveStreamVideo(
          videoPath: videoPathToPost,
          thumbPath: thumbPathToPost,
          title: titleToPost,
        ).catchError((e) {
          logger.e('❌ Error in background video posting: $e');
        });
      } else {
        logger.w('⚠️ No video or thumbnail path to post');
        AIHelpers.showToast(msg: 'No video captured to post');
      }
    } catch (e, stackTrace) {
      setError(e);
      logger.e('❌ Error ending live: $e', stackTrace: stackTrace);
      AIHelpers.showToast(msg: 'Error ending live stream: ${e.toString()}');
      // Ensure state is false even on error
      isLive = false;
      _isToggling = false;
      notifyListeners();
    } finally {
      // Final cleanup (paths are saved in local variables above)
      // Always ensure these are reset
      isLive = false;
      _sessionId = null;
      _liveTitle = '';
      _thumbPath = null;
      _videoPath = null;
      _isRecording = false;
      // Always reset toggling in finally to ensure button works
      _isToggling = false;
      notifyListeners();
      logger.d('✅ _endLive() cleanup completed');
    }
  }

  /// Posts the live stream video in the background (non-blocking)
  Future<void> _postLiveStreamVideo({
    String? videoPath,
    String? thumbPath,
    String? title,
  }) async {
    try {
      List<MediaStoryModel> medias = [];

      // Upload video if available
      if (videoPath != null && videoPath.isNotEmpty) {
        try {
          // Verify file exists before uploading
          final videoFile = File(videoPath);
          if (!await videoFile.exists()) {
            logger.e('❌ Video file does not exist: $videoPath');
            throw Exception('Video file does not exist: $videoPath');
          }

          final fileSize = await videoFile.length();
          logger.d('📤 Uploading video from path: $videoPath');
          logger.d(
            '📊 Video file size: $fileSize bytes (${(fileSize / 1024 / 1024).toStringAsFixed(2)} MB)',
          );

          if (fileSize == 0) {
            logger.e('❌ Video file is empty (0 bytes)');
            throw Exception('Video file is empty');
          }

          if (fileSize < 1000) {
            logger.w(
              '⚠️ Video file is very small ($fileSize bytes) - might be invalid',
            );
          }

          logger.d('🚀 Starting video upload to CDN...');
          final xFile = XFile(videoPath);
          final videoUploaded = await CloudinaryCDNService.uploadVideoToCDN(
            xFile,
          );
          logger.d('📥 Video upload completed');

          if (videoUploaded.link != null && videoUploaded.link!.isNotEmpty) {
            medias.add(
              MediaStoryModel(
                link: videoUploaded.link!,
                type: 'video',
                width: videoUploaded.width ?? 1920,
                height: videoUploaded.height ?? 1080,
              ),
            );
            logger.d('Video uploaded successfully: ${videoUploaded.link}');
            logger.d(
              'Video dimensions: ${videoUploaded.width}x${videoUploaded.height}',
            );
          } else {
            logger.e('Video upload returned empty link');
            throw Exception('Video upload failed: empty link');
          }
        } catch (e, stackTrace) {
          logger.e('Error uploading video: $e', stackTrace: stackTrace);
          // Fallback to thumbnail if video upload fails
          if (thumbPath != null) {
            try {
              logger.d('Falling back to thumbnail: $thumbPath');
              final thumbFile = File(thumbPath);
              if (await thumbFile.exists()) {
                final uploaded = await CloudinaryCDNService.uploadImageToCDN(
                  XFile(thumbPath),
                );
                if ((uploaded.link ?? '').isNotEmpty) {
                  medias.add(uploaded);
                  logger.d('Thumbnail uploaded as fallback: ${uploaded.link}');
                }
              }
            } catch (thumbError) {
              logger.e('Error uploading thumbnail fallback: $thumbError');
            }
          }
        }
      } else if (thumbPath != null) {
        // Fallback to thumbnail if no video
        try {
          final thumbFile = File(thumbPath);
          if (await thumbFile.exists()) {
            final uploaded = await CloudinaryCDNService.uploadImageToCDN(
              XFile(thumbPath),
            );
            if ((uploaded.link ?? '').isNotEmpty) {
              medias.add(uploaded);
            }
          }
        } catch (e) {
          logger.e('Error uploading thumbnail: $e');
        }
      }

      // Use 'regular' category so it shows on dashboard
      // The story will appear in the main feed with the video
      final storyTitle =
          (title != null && title.isNotEmpty) ? title : 'Live Stream';
      final story = StoryModel(
        title: storyTitle,
        text:
            (title != null && title.isNotEmpty)
                ? 'Live stream recording: $title'
                : 'Live stream recording',
        status: 'public',
        category:
            'regular', // Changed from 'live' to 'regular' to show on dashboard
        medias: medias.isNotEmpty ? medias : null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      // Verify medias before posting
      if (medias.isEmpty) {
        logger.w('⚠️ No media to post - skipping story creation');
        logger.w('  Video path was: $videoPath');
        logger.w('  Thumb path was: $thumbPath');
        AIHelpers.showToast(msg: 'No video captured to post');
        return;
      }

      logger.d('📝 Posting story with ${medias.length} media(s)');
      logger.d('📋 Media types: ${medias.map((m) => m.type).join(", ")}');
      for (var i = 0; i < medias.length; i++) {
        final media = medias[i];
        logger.d(
          '  Media $i: type=${media.type}, link=${media.link}, size=${media.width}x${media.height}',
        );
      }

      logger.d('💾 Saving story to database...');
      final storyId = await storyService.postStory(story: story);
      logger.d('✅ Story posted successfully!');
      logger.d('  Story ID: $storyId');
      logger.d('  Media count: ${medias.length}');
      logger.d('  Category: ${story.category}');
      logger.d('  Status: ${story.status}');

      // Trigger story update to refresh dashboard
      try {
        await storyService.updateStoryUpdated();
        logger.d('Story update notification triggered');
      } catch (e) {
        logger.w('Failed to trigger story update: $e');
      }

      if (medias.isNotEmpty && medias.first.type == 'video') {
        AIHelpers.showToast(msg: 'Live stream video posted to dashboard!');
      } else if (medias.isNotEmpty) {
        AIHelpers.showToast(msg: 'Live stream posted to dashboard!');
      }
    } catch (e) {
      logger.e(
        'Error posting story: $e',
        stackTrace: e is Error ? StackTrace.current : null,
      );
      AIHelpers.showToast(msg: 'Failed to post live stream: ${e.toString()}');
    }

    // Cleanup Stream SDK and camera (after posting is done)
    try {
      await StreamVideoService().leave();
    } catch (_) {}

    try {
      await _cameraController?.dispose();
    } catch (_) {}
    _cameraController = null;
    _isInitialized = false;
    notifyListeners();
  }

  Future<void> endLiveIfActive() async {
    if (isLive) {
      logger.d('🛑 endLiveIfActive() called - ending live stream');
      // Set state immediately for UI feedback
      isLive = false;
      _isToggling = true;
      notifyListeners();

      try {
        await _endLive();
      } catch (e, stackTrace) {
        logger.e('❌ Error in endLiveIfActive: $e', stackTrace: stackTrace);
        rethrow;
      } finally {
        _isToggling = false;
        notifyListeners();
      }
    } else {
      logger.d('⚠️ endLiveIfActive() called but isLive is false');
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }
}
