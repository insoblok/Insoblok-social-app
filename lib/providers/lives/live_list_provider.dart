import 'dart:async';

import 'package:flutter/material.dart';

import 'package:insoblok/models/live_session_model.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/pages/lives/live_viewer_page.dart';

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
    Routers.goToLiveStreamPage(context);
  }

  void onTapSession(LiveSessionModel s) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => LiveViewerPage(session: s)),
    );
  }

  void onTapPlaceholder(int index) {
    final demo = LiveSessionModel(
      id: 'demo-$index',
      userId: '',
      userName: 'Creator $index',
      userAvatar: null,
      title: 'Live',
      status: 'live',
    );
    onTapSession(demo);
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}


