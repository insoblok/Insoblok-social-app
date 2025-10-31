import 'package:stream_video_flutter/stream_video_flutter.dart';

class StreamVideoService {
  static final StreamVideoService _instance = StreamVideoService._internal();
  factory StreamVideoService() => _instance;
  StreamVideoService._internal();

  StreamVideo? _client;
  Call? _activeCall;

  Call? get activeCall => _activeCall;

  Future<void> connect({
    required String apiKey,
    required String userId,
    required String userName,
    required String userToken,
  }) async {
    // If already connected with same user, skip
    if (_client != null) return;
    _client = StreamVideo(
      apiKey,
      user: User.regular(userId: userId, name: userName),
      userToken: userToken,
    );
  }

  Future<Call> joinLivestream({
    required String callId,
    bool asHost = false,
  }) async {
    if (_client == null) {
      throw StateError('StreamVideo client is not connected');
    }
    final call = _client!.makeCall(
      callType: StreamCallType.defaultType(),
      id: callId,
    );
    await call.join();
    if (asHost) {
      try {
        await call.goLive();
      } catch (_) {}
    }
    _activeCall = call;
    return call;
  }

  Future<void> leave() async {
    try {
      await _activeCall?.leave();
    } finally {
      _activeCall = null;
    }
  }
}


