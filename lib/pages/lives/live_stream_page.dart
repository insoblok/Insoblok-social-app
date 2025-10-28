import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:camera/camera.dart';

import 'package:insoblok/providers/lives/live_stream_provider.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/extensions/extensions.dart';

class LiveStreamPage extends StatelessWidget {
  const LiveStreamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LiveStreamProvider>.reactive(
      viewModelBuilder: () => LiveStreamProvider(),
      onViewModelReady: (vm) => vm.init(context),
      builder: (context, vm, _) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: WillPopScope(
            onWillPop: () async {
              await vm.endLiveIfActive();
              return true;
            },
            child: Stack(
            fit: StackFit.expand,
            children: [
              if (vm.isInitialized && vm.cameraController != null)
                CameraPreview(vm.cameraController!)
              else
                const Center(child: CircularProgressIndicator()),

              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          await vm.endLiveIfActive();
                          // ignore: use_build_context_synchronously
                          Navigator.of(context).maybePop();
                        },
                        icon: const Icon(Icons.close, color: Colors.white),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.redAccent.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'LIVE',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
              ),

              Positioned(
                left: 0,
                right: 0,
                bottom: 40 + MediaQuery.of(context).padding.bottom,
                child: Center(
                  child: GestureDetector(
                    onTap: () async {
                      final wasLive = vm.isLive;
                      await vm.toggleLive();
                      if (wasLive) {
                        // Ending live: leave screen
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).maybePop();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFF30C6C), Color(0xFFC739EB)],
                        ),
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(vm.isLive ? Icons.stop_circle : Icons.videocam, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            vm.isLive ? 'End Live' : 'Start Live',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Chat overlay (simple)
              if (vm.isLive && vm.sessionId != null)
                Align(
                  alignment: Alignment.bottomLeft,
                  child: SafeArea(
                    minimum: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
                    child: _LiveChat(sessionId: vm.sessionId!),
                  ),
                ),
            ],
          ),
        ),
        );
      },
    );
  }
}

class _LiveChat extends StatefulWidget {
  final String sessionId;
  const _LiveChat({required this.sessionId});

  @override
  State<_LiveChat> createState() => _LiveChatState();
}

class _LiveChatState extends State<_LiveChat> {
  final _controller = TextEditingController();
  final _liveService = LiveService();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxHeight: 180),
          child: StreamBuilder<List<Map<String, dynamic>>>(
            stream: _liveService.messagesStream(widget.sessionId),
            builder: (context, snapshot) {
              final items = snapshot.data ?? const [];
              return ListView.builder(
                reverse: true,
                itemCount: items.length,
                itemBuilder: (_, i) {
                  final m = items[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text(
                      '${m['userName'] ?? 'User'}: ${m['text'] ?? ''}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                },
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  isDense: true,
                  filled: true,
                  fillColor: Colors.black54,
                  hintText: 'Say something...',
                  hintStyle: const TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                onSubmitted: (_) => _send(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: _send,
              icon: const Icon(Icons.send, color: Colors.white),
            )
          ],
        )
      ],
    );
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();
    await _liveService.sendMessage(widget.sessionId, {
      'text': text,
      // Keep minimal user info inline for display
      'userId': AuthHelper.user?.id,
      'userName': AuthHelper.user?.fullName ?? 'User',
      'userAvatar': AuthHelper.user?.avatar,
    });
  }
}


