import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:insoblok/pages/vtos/deep_ar_plus_surface.dart';
import 'package:insoblok/services/deep_ar_plus_service.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/routers/router.dart';
import 'package:deepar_flutter_plus/deepar_flutter_plus.dart';

/// TikTok-like create post capture screen using DeepAR.
/// - Record up to 30 seconds of video with filters
/// - Switch to Text mode to redirect to Add Story page
class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final DeepArPlusService _deepAr = DeepArPlusService();

  // Local copy of DeepAR effect list (kept simple; same assets as integrated)
  static const List<Map<String, String>> kDeeparEffectData = [
    {'title': 'Fire', 'assets': 'assets/effects/filters/fire_effect/Fire_Effect.deepar'},
    {'title': 'Vendetta', 'assets': 'assets/effects/filters/vendetta_mask/Vendetta_Mask.deepar'},
    {'title': 'Flower', 'assets': 'assets/effects/filters/flower_face/flower_face.deepar'},
    {'title': 'Devil Neon Horns', 'assets': 'assets/effects/filters/devil_neon_horns/Neon_Devil_Horns.deepar'},
    {'title': 'Elephant Trunk', 'assets': 'assets/effects/filters/elephant_trunk/Elephant_Trunk.deepar'},
    {'title': 'Emotion Meter', 'assets': 'assets/effects/filters/emotion_meter/Emotion_Meter.deepar'},
    {'title': 'Emotions Exaggerator', 'assets': 'assets/effects/filters/emotions_exaggerator/Emotions_Exaggerator.deepar'},
    {'title': 'Heart', 'assets': 'assets/effects/filters/heart/8bitHearts.deepar'},
    {'title': 'Hope', 'assets': 'assets/effects/filters/hope/Hope.deepar'},
    {'title': 'Humanoid', 'assets': 'assets/effects/filters/humanoid/Humanoid.deepar'},
    {'title': 'Ping Pong', 'assets': 'assets/effects/filters/ping_pong/Ping_Pong.deepar'},
    {'title': 'Simple', 'assets': 'assets/effects/filters/simple/MakeupLook.deepar'},
    {'title': 'Slipt', 'assets': 'assets/effects/filters/slipt/Split_View_Look.deepar'},
    {'title': 'Snail', 'assets': 'assets/effects/filters/snail/Snail.deepar'},
    {'title': 'Stallone', 'assets': 'assets/effects/filters/stallone/Stallone.deepar'},
    {'title': 'Viking Helmet', 'assets': 'assets/effects/filters/viking_helmet/viking_helmet.deepar'},
  ];

  int _maxSeconds = 30; // requirement: maximum length 30s
  int _remaining = 0;
  Timer? _ticker;
  bool _isLoading = false;
  bool _showFilters = true; // simple on-page chips like sample

  // zoom helpers
  static const double _minZoom = 1.0;
  static const double _maxZoom = 4.0;
  double _zoom = 1.0;
  double _zoomStart = 1.0;

  // Right-side tools state
  double _speedFactor = 1.0; // 0.3x, 0.5x, 1x, 2x, 3x (UI only)
  bool _beautyOn = false;
  bool _flashOn = false;
  int _preCountdownSeconds = 0; // 0/3/10
  int _preCountdownRemaining = 0;
  Timer? _preTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _deepAr.initialize(
        androidKey: DEEPAR_ANDROID_KEY,
        iosKey: DEEPAR_IOS_KEY,
        resolution: Resolution.medium,
      );
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _deepAr.disposeEngine();
    super.dispose();
  }

  bool get _isRecording => _deepAr.isRecording;

  Future<void> _startRecording() async {
    if (!_deepAr.isReady || _isRecording) return;
    await _deepAr.startRecording();
    if (!mounted) return;
    setState(() => _remaining = _maxSeconds);

    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (t) async {
      if (!mounted) return t.cancel();
      if (_remaining <= 1) {
        await _stopRecording(autoProceed: true);
      } else {
        setState(() => _remaining -= 1);
      }
    });
  }

  Future<void> _stopRecording({bool autoProceed = false}) async {
    _ticker?.cancel();
    setState(() => _isLoading = true);
    File? f;
    try {
      f = await _deepAr.stopRecording();
    } finally {
      if (!mounted) return;
      setState(() {
        _remaining = 0;
        _isLoading = false;
      });
    }
    if (!mounted || f == null) return;

    if (autoProceed) {
      Routers.goToVideoEditorPage(context, f.path);
    }
  }

  Future<void> _toggleFlash() async {
    try {
      final ctrl = _deepAr.controller as dynamic;
      if (ctrl.toggleFlash != null) {
        await ctrl.toggleFlash();
        setState(() => _flashOn = !_flashOn);
      } else if (ctrl.setFlashlight != null) {
        await ctrl.setFlashlight(!_flashOn);
        setState(() => _flashOn = !_flashOn);
      }
    } catch (_) {}
  }

  Future<void> _toggleBeauty() async {
    const simplePath = 'assets/effects/filters/simple/MakeupLook.deepar';
    if (!_deepAr.isReady) return;
    if (_beautyOn) {
      try {
        await _deepAr.switchEffect('');
      } catch (_) {}
      setState(() => _beautyOn = false);
    } else {
      try {
        await _deepAr.switchEffect(simplePath);
        setState(() => _beautyOn = true);
      } catch (_) {}
    }
  }

  void _chooseSpeed() {
    if (_isRecording || _isLoading) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black87,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        Widget speedItem(String label, double v) {
          final selected = _speedFactor == v;
          return ListTile(
            title: Text(label, style: TextStyle(color: selected ? Colors.pink : Colors.white)),
            onTap: () {
              Navigator.pop(ctx);
              setState(() => _speedFactor = v);
            },
          );
        }
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              speedItem('0.3x', 0.3),
              speedItem('0.5x', 0.5),
              speedItem('1x', 1.0),
              speedItem('2x', 2.0),
              speedItem('3x', 3.0),
            ],
          ),
        );
      },
    );
  }

  void _chooseTimer() {
    if (_isRecording || _isLoading) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black87,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        Widget item(String label, int sec) {
          final selected = _preCountdownSeconds == sec;
          return ListTile(
            title: Text(label, style: TextStyle(color: selected ? Colors.pink : Colors.white)),
            onTap: () {
              Navigator.pop(ctx);
              setState(() => _preCountdownSeconds = sec);
            },
          );
        }
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              item('Off', 0),
              item('3s', 3),
              item('10s', 10),
            ],
          ),
        );
      },
    );
  }

  Future<void> _startWithPreTimerOrRecord() async {
    if (_preCountdownSeconds <= 0) {
      await _startRecording();
      return;
    }
    setState(() => _preCountdownRemaining = _preCountdownSeconds);
    _preTimer?.cancel();
    _preTimer = Timer.periodic(const Duration(seconds: 1), (t) async {
      if (!mounted) return t.cancel();
      if (_preCountdownRemaining <= 1) {
        t.cancel();
        if (!mounted) return;
        setState(() => _preCountdownRemaining = 0);
        await _startRecording();
      } else {
        setState(() => _preCountdownRemaining -= 1);
      }
    });
  }

  void _setZoom(double next) {
    final clamped = next.clamp(_minZoom, _maxZoom);
    if (clamped == _zoom) return;
    setState(() => _zoom = clamped);
    try {
      (_deepAr.controller as dynamic).setZoom(_zoom);
    } catch (_) {}
  }

  Widget _buildRightTools() {
    Widget circle(IconData icon, VoidCallback? onTap, {Color? color}) {
      return InkWell(
        onTap: onTap,
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.35),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color ?? Colors.white),
        ),
      );
    }

    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 12, top: 90, bottom: 140),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 14,
          children: [
            circle(Icons.cameraswitch, _deepAr.isReady ? _deepAr.switchCamera : null),
            circle(Icons.speed, _chooseSpeed),
            circle(Icons.face_retouching_natural, _toggleBeauty, color: _beautyOn ? Colors.pink : null),
            circle(Icons.filter_vintage, () => setState(() => _showFilters = !_showFilters)),
            circle(Icons.timer, _chooseTimer, color: _preCountdownSeconds > 0 ? Colors.pink : null),
            circle(_flashOn ? Icons.flash_on : Icons.flash_off, _toggleFlash),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close, color: Colors.white),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                spacing: 6,
                children: const [
                  Icon(Icons.music_note, color: Colors.white, size: 18),
                  Text('Add sound', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    if (!_showFilters) return const SizedBox.shrink();
    return Positioned(
      top: 56,
      left: 0,
      right: 0,
      child: SizedBox(
        height: 46,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          scrollDirection: Axis.horizontal,
          itemCount: kDeeparEffectData.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, i) {
            final item = kDeeparEffectData[i];
            final title = (item['title'] ?? '').toString();
            final path = (item['assets'] ?? '').toString();
            final enabled = _deepAr.isReady && path.isNotEmpty && !_isLoading;
            return FilterChip(
              label: Text(title.isEmpty ? 'Effect ${i + 1}' : title),
              onSelected: enabled
                  ? (_) async => _deepAr.switchEffect(path)
                  : null,
              selected: false,
            );
          },
        ),
      ),
    );
  }

  Widget _buildModeSwitcher() {
    // Two modes: VIDEO and TEXT
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 24,
      children: [
        Text('VIDEO', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white)),
        InkWell(
          onTap: () => Routers.goToAddStoryPage(context),
          child: Text('TEXT', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white70)),
        ),
      ],
    );
  }

  Widget _buildDurationSelector() {
    final durations = const [15, 30, 60];
    int currentIndex = durations.indexOf(_maxSeconds);
    if (currentIndex < 0) currentIndex = 1;

    Widget chip(int seconds, bool selected) {
      return GestureDetector(
        onTap: _isRecording || _isLoading
            ? null
            : () {
                setState(() => _maxSeconds = seconds);
              },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: selected ? Colors.pink : Colors.white24,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            '${seconds}s',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 8,
      children: [
        chip(15, currentIndex == 0),
        chip(30, currentIndex == 1),
        chip(60, currentIndex == 2),
      ],
    );
  }

  Widget _buildCaptureBar() {
    final canCapture = _deepAr.isReady && !_isLoading;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildModeSwitcher(),
            const SizedBox(height: 8),
            _buildDurationSelector(),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: !canCapture
                      ? null
                      : () async {
                          if (_isRecording) {
                            await _stopRecording(autoProceed: true);
                          } else {
                            await _startWithPreTimerOrRecord();
                          }
                          if (mounted) setState(() {});
                        },
                  child: Container(
                    width: 74,
                    height: 74,
                    decoration: BoxDecoration(
                      color: _isRecording ? Colors.red : Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Container(
                        width: 62,
                        height: 62,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54, width: 2),
                          shape: BoxShape.circle,
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            if (_isRecording)
              Text('$_remaining s', style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          if (_deepAr.isReady)
            GestureDetector(
              onScaleStart: (d) => _zoomStart = _zoom,
              onScaleUpdate: (d) {
                if (d.scale != 1.0) {
                  _setZoom(_zoomStart * d.scale);
                }
              },
              child: Positioned.fill(
                child: DeepArPlusSurface(
                  service: _deepAr,
                  scale: _deepAr.aspectRatio * 1.3 * _zoom,
                ),
              ),
            )
          else
            const Center(child: CircularProgressIndicator()),

          _buildTopBar(),
          _buildFilterChips(),
          _buildRightTools(),

          if (_preCountdownRemaining > 0)
            Positioned.fill(
              child: Container(
                color: Colors.black38,
                child: Center(
                  child: Text(
                    '$_preCountdownRemaining',
                    style: const TextStyle(color: Colors.white, fontSize: 72, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),

          if (_isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black45,
                child: const Center(child: CircularProgressIndicator()),
              ),
            ),

          Align(alignment: Alignment.bottomCenter, child: _buildCaptureBar()),
        ],
      ),
    );
  }
}


