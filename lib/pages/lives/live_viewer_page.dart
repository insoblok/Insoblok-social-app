import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'package:insoblok/models/live_session_model.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:insoblok/services/stream_video_service.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:insoblok/utils/utils.dart';

class LiveViewerPage extends StatefulWidget {
  final LiveSessionModel session;
  const LiveViewerPage({super.key, required this.session});

  @override
  State<LiveViewerPage> createState() => _LiveViewerPageState();
}

class _LiveViewerPageState extends State<LiveViewerPage> {
  late final VideoPlayerController _controller;
  bool _ready = false;
  Call? _call;

  bool get isDemo => widget.session.id.startsWith('demo');

  @override
  void initState() {
    super.initState();
    if (!isDemo && (widget.session.callId != null)) {
      _joinStreamAsViewer(widget.session.callId!);
    } else {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse('https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'),
      )
        ..setLooping(true)
        ..initialize().then((_) {
          if (mounted) {
            setState(() => _ready = true);
            _controller.play();
          }
        });
    }
  }

  @override
  void dispose() {
    try { _controller.dispose(); } catch (_) {}
    try { StreamVideoService().leave(); } catch (_) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (_call != null)
            Container(
              color: Colors.black,
              alignment: Alignment.center,
              child: const Text('Connected to live', style: TextStyle(color: Colors.white)),
            )
          else if (_ready)
            FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: VideoPlayer(_controller),
              ),
            )
          else
            const Center(child: CircularProgressIndicator()),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  const SizedBox(width: 6),
                  CircleAvatar(
                    radius: 14,
                    backgroundImage: widget.session.userAvatar != null ? NetworkImage(widget.session.userAvatar!) : null,
                    backgroundColor: Colors.white12,
                    child: widget.session.userAvatar == null ? const Icon(Icons.person, size: 16, color: Colors.white70) : null,
                  ),
                  const SizedBox(width: 8),
                  Text(widget.session.userName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(color: Colors.redAccent.withOpacity(0.85), borderRadius: BorderRadius.circular(20)),
                    child: const Text('LIVE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 24 + MediaQuery.of(context).padding.bottom,
            child: Center(
              child: Opacity(
                opacity: 0.85,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    isDemo ? 'Simulated live stream' : 'Live viewer',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Future<void> _joinStreamAsViewer(String callId) async {
    try {
      final res = await FirebaseFunctions.instance.httpsCallable('videoTokenV2').call();
      final data = (res.data as Map).cast<String, dynamic>();
      final apiKey = data['apiKey'] as String?;
      final userToken = data['token'] as String?;
      final userId = data['userId'] as String?;
      final userName = 'Viewer';
      if (apiKey != null && userToken != null && userId != null) {
        final stream = StreamVideoService();
        await stream.connect(apiKey: apiKey, userId: userId, userName: userName, userToken: userToken);
        final c = await stream.joinLivestream(callId: callId, asHost: false);
        if (mounted) setState(() => _call = c);
      }
    } catch (e) {
      if (mounted) setState(() => _ready = false);
    }
  }
}
