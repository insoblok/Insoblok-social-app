import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:camera/camera.dart';

import 'package:insoblok/providers/lives/live_stream_provider.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:insoblok/services/stream_video_service.dart';

class LiveStreamPage extends StatelessWidget {
  final String? initialTitle;
  const LiveStreamPage({super.key, this.initialTitle});

  static Future<String?> _showTitleDialog(
    BuildContext context,
    String currentTitle,
  ) {
    final controller = TextEditingController(text: currentTitle);
    return showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            final length = controller.text.trim().length;
            final bool valid = length >= 10 && length <= 60;
            return AlertDialog(
              backgroundColor: Colors.black87,
              titlePadding: const EdgeInsets.only(
                left: 16,
                right: 8,
                top: 12,
                bottom: 0,
              ),
              title: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Set stream title',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  TextButton(
                    onPressed:
                        valid
                            ? () => Navigator.of(
                              context,
                            ).pop(controller.text.trim())
                            : null,
                    child: const Text('OK'),
                  ),
                  IconButton(
                    tooltip: 'Close',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: Colors.white70),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: controller,
                    autofocus: true,
                    maxLength: 60,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      counterText: '',
                      hintText: 'At least 10 characters, up to 60',
                      hintStyle: TextStyle(color: Colors.white54),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${length}/60',
                    style: TextStyle(
                      color: valid ? Colors.white60 : Colors.redAccent,
                    ),
                  ),
                ],
              ),
              actions: const [],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LiveStreamProvider>.reactive(
      viewModelBuilder: () => LiveStreamProvider(),
      onViewModelReady: (vm) {
        vm.init(context);
        final argTitle = ModalRoute.of(context)?.settings.arguments as String?;
        final fromCtor = initialTitle;
        final t =
            (fromCtor != null && fromCtor.isNotEmpty)
                ? fromCtor
                : (argTitle ?? '');
        if (t.isNotEmpty) {
          vm.liveTitle = t.trim();
        }
      },
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
                Builder(
                  builder: (_) {
                    final activeCall = StreamVideoService().activeCall;
                    if (activeCall != null) {
                      return LivestreamPlayer(call: activeCall);
                    }
                    if (vm.isInitialized && vm.cameraController != null) {
                      return CameraPreview(vm.cameraController!);
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),

                SafeArea(
                  child: Stack(
                    children: [
                      Positioned(
                        top: 4,
                        left: 4,
                        child: IconButton(
                          onPressed: () async {
                            await vm.endLiveIfActive();
                            // ignore: use_build_context_synchronously
                            Navigator.of(context).maybePop();
                          },
                          icon: const Icon(Icons.close, color: Colors.white),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.redAccent.withOpacity(0.85),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'LIVE',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 40 + MediaQuery.of(context).padding.bottom,
                  child: Center(
                    child: GestureDetector(
                      onTap: () async {
                        // Always allow tap, but check state inside
                        if (vm.isToggling) {
                          debugPrint(
                            '⚠️ Button tap ignored - already toggling',
                          );
                          return;
                        }

                        try {
                          final wasLive = vm.isLive;
                          debugPrint(
                            '🖱️ Button tapped. wasLive: $wasLive, isLive: ${vm.isLive}, isToggling: ${vm.isToggling}',
                          );

                          // Enforce title length: 10..60 to allow starting
                          final validTitle =
                              vm.liveTitle.trim().length >= 10 &&
                              vm.liveTitle.trim().length <= 60;
                          if (!wasLive && !validTitle) {
                            // Show dialog to set title
                            final title = await _showTitleDialog(
                              context,
                              vm.liveTitle,
                            );
                            if (title != null && title.trim().isNotEmpty) {
                              vm.liveTitle = title.trim();
                            } else {
                              // User cancelled or didn't enter valid title
                              return;
                            }
                            // Re-check validity after setting title
                            final newValidTitle =
                                vm.liveTitle.trim().length >= 10 &&
                                vm.liveTitle.trim().length <= 60;
                            if (!newValidTitle) {
                              AIHelpers.showToast(
                                msg: 'Title must be 10-60 characters',
                              );
                              return;
                            }
                          }

                          if (wasLive) {
                            // Ending live: stop recording and navigate back
                            // Video posting will continue in background
                            debugPrint('🛑 Ending live stream...');

                            // Call endLive - it will stop recording and post video in background
                            // It handles state updates internally
                            vm
                                .endLiveIfActive()
                                .then((_) {
                                  debugPrint(
                                    '✅ Live stream ended successfully',
                                  );
                                  // Navigate back after critical operations complete
                                  if (context.mounted) {
                                    debugPrint(
                                      '🔙 Navigating back to previous page...',
                                    );
                                    Navigator.of(context).maybePop();
                                  }
                                })
                                .catchError((e) {
                                  debugPrint('❌ Error ending live: $e');
                                  AIHelpers.showToast(
                                    msg: 'Error ending live: ${e.toString()}',
                                  );
                                  // Still navigate back even on error
                                  if (context.mounted) {
                                    Navigator.of(context).maybePop();
                                  }
                                });
                          } else {
                            // Starting live: use toggleLive
                            vm.toggleLive().catchError((e) {
                              debugPrint('❌ Error in toggleLive: $e');
                              AIHelpers.showToast(
                                msg: 'Error: ${e.toString()}',
                              );
                            });
                          }

                          debugPrint(
                            '🖱️ Action called. isLive: ${vm.isLive}, isToggling: ${vm.isToggling}',
                          );
                        } catch (e) {
                          debugPrint('❌ Error in button tap handler: $e');
                          AIHelpers.showToast(msg: 'Error: ${e.toString()}');
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 26,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              (vm.isToggling ||
                                      (!vm.isLive &&
                                          (vm.liveTitle.trim().length < 10 ||
                                              vm.liveTitle.trim().length > 60)))
                                  ? Colors.grey
                                  : const Color(0xFFF30C6C),
                              (vm.isToggling ||
                                      (!vm.isLive &&
                                          (vm.liveTitle.trim().length < 10 ||
                                              vm.liveTitle.trim().length > 60)))
                                  ? Colors.grey
                                  : const Color(0xFFC739EB),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (vm.isToggling)
                              const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            else
                              Icon(
                                vm.isLive ? Icons.stop_circle : Icons.videocam,
                                color: Colors.white,
                              ),
                            const SizedBox(width: 8),
                            Text(
                              vm.isToggling
                                  ? (vm.isLive ? 'Starting...' : 'Ending...')
                                  : (vm.isLive ? 'End Live' : 'Start Live'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
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
                      minimum: const EdgeInsets.only(
                        left: 12,
                        right: 12,
                        bottom: 12,
                      ),
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
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                onSubmitted: (_) => _send(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: _send,
              icon: const Icon(Icons.send, color: Colors.white),
            ),
          ],
        ),
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
