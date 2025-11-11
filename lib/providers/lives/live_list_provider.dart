import 'dart:async';

import 'package:flutter/material.dart';

import 'package:insoblok/models/live_session_model.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/pages/lives/live_viewer_page.dart';
import 'package:insoblok/pages/lives/live_stream_page.dart';

class LiveListProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext c) { _context = c; }

  final LiveService _liveService = LiveService();

  StreamSubscription? _sub;
  final List<LiveSessionModel> _sessions = [];
  List<LiveSessionModel> get sessions => List.unmodifiable(_sessions);

  Future<void> init(BuildContext context) async {
    this.context = context;
    _sub = _liveService.liveSessionsStream().listen((items) {
      final currentUserId = AuthHelper.user?.id;
      _sessions
        ..clear()
        ..addAll(
          items
              .map((e) => LiveSessionModel.fromMap(e))
              .where((s) => s.userId != currentUserId),
        );
      notifyListeners();
    });
  }

  void onTapCreateLive() {
    final controller = TextEditingController();
    showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            final length = controller.text.trim().length;
            final bool valid = length >= 10 && length <= 60;
            return AlertDialog(
              backgroundColor: Colors.black87,
              titlePadding: const EdgeInsets.only(left: 16, right: 8, top: 12, bottom: 0),
              title: Row(
                children: [
                  const Expanded(
                    child: Text('Set stream title', style: TextStyle(color: Colors.white)),
                  ),
                  TextButton(
                    onPressed: valid
                        ? () => Navigator.of(context).pop(controller.text.trim())
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
                    style: TextStyle(color: valid ? Colors.white60 : Colors.redAccent),
                  ),
                ],
              ),
              actions: const [],
            );
          },
        );
      },
    ).then((title) {
      if (title is String && title.trim().isNotEmpty) {
        Navigator.of(context).push(
          MaterialPageRoute(
            settings: RouteSettings(arguments: title.trim()),
            builder: (_) => const LiveStreamPage(),
          ),
        );
      }
    });
  }

  void onTapSession(LiveSessionModel s) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => LiveViewerPage(session: s)),
    );
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}


