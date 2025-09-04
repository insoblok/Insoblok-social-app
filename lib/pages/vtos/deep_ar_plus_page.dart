// deep_ar_plus_page.dart
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:deepar_flutter_plus/deepar_flutter_plus.dart';
import 'package:insoblok/services/image_service.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/services/deep_ar_plus_service.dart';
import 'deep_ar_plus_surface.dart';

final kDeeparEffectData = [
  {'title': 'Fire', 'assets': "assets/effects/filters/fire_effect/Fire_Effect.deepar"},
  {'title': 'Vendetta', 'assets': "assets/effects/filters/vendetta_mask/Vendetta_Mask.deepar"},
  {'title': 'Flower', 'assets': "assets/effects/filters/flower_face/flower_face.deepar"},
  {'title': 'Devil Neon Horns', 'assets': "assets/effects/filters/devil_neon_horns/Neon_Devil_Horns.deepar"},
  {'title': 'Elephant Trunk', 'assets': "assets/effects/filters/elephant_trunk/Elephant_Trunk.deepar"},
  {'title': 'Emotion Meter', 'assets': "assets/effects/filters/emotion_meter/Emotion_Meter.deepar"},
  {'title': 'Emotions Exaggerator', 'assets': "assets/effects/filters/emotions_exaggerator/Emotions_Exaggerator.deepar"},
  {'title': 'Heart', 'assets': "assets/effects/filters/heart/8bitHearts.deepar"},
  {'title': 'Hope', 'assets': "assets/effects/filters/hope/Hope.deepar"},
  {'title': 'Humanoid', 'assets': "assets/effects/filters/humanoid/Humanoid.deepar"},
  {'title': 'Ping Pong', 'assets': "assets/effects/filters/ping_pong/Ping_Pong.deepar"},
  {'title': 'Simple', 'assets': "assets/effects/filters/simple/MakeupLook.deepar"},
  {'title': 'Slipt', 'assets': "assets/effects/filters/slipt/Split_View_Look.deepar"},
  {'title': 'Snail', 'assets': "assets/effects/filters/snail/Snail.deepar"},
  {'title': 'Stallone', 'assets': "assets/effects/filters/stallone/Stallone.deepar"},
  {'title': 'Viking Helmet', 'assets': "assets/effects/filters/viking_helmet/viking_helmet.deepar"},
];

final deepAr = DeepArPlusService();

class DeepARPlusPage extends StatefulWidget {
  const DeepARPlusPage({super.key});
  @override
  State<DeepARPlusPage> createState() => _DeepARPlusPageState();
}

class _DeepARPlusPageState extends State<DeepARPlusPage> {
  File? lastPhoto;
  File? lastVideo;

  final int _maxSeconds = 10;   
  int _remaining = 0;
  bool _isFiltering = false;
  bool _isVideoLoading = false;

  Timer? _ticker;
  bool get _isRecording => deepAr.isRecording;

  static const double _minZoom = 1.0;
  static const double _maxZoom = 4.0;
  double _zoom = 1.0;                    // current zoom factor
  double _zoomStart = 1.0;               // base for pinch gesture
  bool _showZoomBadge = false;           // fades out after interaction
  Timer? _zoomBadgeTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await deepAr.initialize(
        androidKey: DEEPAR_ANDROID_KEY,
        iosKey: DEEPAR_IOS_KEY,
        resolution: Resolution.medium,
        initialEffect: '',
      );
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _zoomBadgeTimer?.cancel();
    deepAr.disposeEngine();
    super.dispose();
  }

  void _finishAndReturn() {
    Navigator.of(context).pop(<String, String?>{
      'photo': lastPhoto?.path,
      'video': lastVideo?.path,
    });
  }

  void _onSwitchCameraPressed() async {
    try {
      await deepAr.switchCamera();
    } catch (e) {
      debugPrint('Switch camera failed: $e');
    }
  }


  Future<void> _applyHardwareZoom(double z) async {
    try {
      await (deepAr.controller as dynamic).setZoom(z);
    } catch (_) {
    }
  }

  void _setZoom(double next) {
    final clamped = next.clamp(_minZoom, _maxZoom);
    if (clamped == _zoom) return;
    setState(() {
      _zoom = clamped;
      _showZoomBadge = true;
    });
    _applyHardwareZoom(_zoom);

    _zoomBadgeTimer?.cancel();
    _zoomBadgeTimer = Timer(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() => _showZoomBadge = false);
    });
  }

  Future<void> _startRecordingWithTimer() async {
    if (!deepAr.isReady || _isRecording) return;

    await deepAr.startRecording();
    if (!mounted) return;

    if (_maxSeconds <= 0) {
      setState(() {
        _isFiltering = true;
        _remaining = 0;
      });
      return;
    }

    setState(() {
      _isFiltering = true;
      _remaining = _maxSeconds;
    });

    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (t) async {
      if (!mounted) {
        t.cancel();
        return;
      }
      if (_remaining <= 1) {
        setState(() => _isFiltering = false);
        await _stopRecordingAndClearTimer(autoReturn: true);
      } else {
        setState(() => _remaining -= 1);
      }
    });
  }

  Future<void> _stopRecordingAndClearTimer({bool autoReturn = false}) async {
    _ticker?.cancel();
    _ticker = null;

    setState(() {
      _isVideoLoading = true;  
      _isFiltering = false;    
    });

    File? result;
    try {
      result = await deepAr.stopRecording();
    } finally {
      if (!mounted) return;
      setState(() {
        _remaining = 0;
        _isVideoLoading = false;
      });
    }

    if (!mounted) return;

    if (result != null) {
      setState(() => lastVideo = result);
      if (autoReturn) {
        Navigator.pop(context, {'video': result.path});
      }
    }
  }

  Widget _recordTimerOverlay() {
    if (!_isFiltering) return const SizedBox.shrink();

    final progress = _maxSeconds == 0
        ? null
        : (1 - (_remaining / _maxSeconds).clamp(0.0, 1.0));

    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.65),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.fiber_manual_record, size: 16, color: Colors.redAccent),
                    const SizedBox(width: 8),
                    Text(
                      _maxSeconds == 0 ? 'REC' : '$_remaining s',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              if (progress != null)
                SizedBox(
                  width: 160,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 4,
                      backgroundColor: Colors.white.withOpacity(0.25),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _loadingOverlay() {
    if (!_isVideoLoading) return const SizedBox.shrink();
    return Positioned.fill(
      child: IgnorePointer(
        ignoring: false,
        child: Container(
          color: Colors.black.withOpacity(0.45),
          child: const Center(
            child: SizedBox(
              width: 56,
              height: 56,
              child: CircularProgressIndicator(strokeWidth: 4),
            ),
          ),
        ),
      ),
    );
  }

  Widget _zoomOverlay() {
    if (_isVideoLoading) return const SizedBox.shrink();

    return SafeArea(
      child: Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.only(right: 8, top: 60, bottom: 60),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedOpacity(
                opacity: _showZoomBadge ? 1 : 0,
                duration: const Duration(milliseconds: 150),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${_zoom.toStringAsFixed(1)}x',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
              RotatedBox(
                quarterTurns: 3,
                child: Slider(
                  value: _zoom,
                  min: _minZoom,
                  max: _maxZoom,
                  label: '${_zoom.toStringAsFixed(1)}x',
                  onChanged: (v) => _setZoom(v),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pinchZoomWrapper({required Widget child}) {
    return GestureDetector(
      onScaleStart: (d) {
        _zoomStart = _zoom;
      },
      onScaleUpdate: (d) {
        if (d.scale != 1.0) {
          _setZoom(_zoomStart * d.scale);
        }
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final canCapture = deepAr.isReady;

    return Scaffold(
      appBar: AppBar(
        title: const Text('DeepAR Filter'),
        actions: [
          // Icon will appear beside "Done" (to its left in LTR locales).
          IconButton(
            tooltip: 'Switch camera',
            onPressed: _onSwitchCameraPressed,
            icon: const Icon(Icons.cameraswitch_outlined),
          ),
          TextButton(
            onPressed: _finishAndReturn,
            child: const Text('Done'),
          ),
        ],
      ),

      body: Stack(
        children: [
          Positioned.fill(
            child: _pinchZoomWrapper(
              child: DeepArPlusSurface(
                service: deepAr,
                scale: deepAr.aspectRatio * 1.3 * _zoom,
              ),
            ),
          ),

          Positioned(
            top: 8,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(12),
                ),
                height: 48, // bar height
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  itemCount: kDeeparEffectData.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    final item  = kDeeparEffectData[i];
                    final title = (item['title'] ?? '').toString();
                    final path  = (item['assets'] ?? '').toString();

                    return FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.pink,   // item color (button background)
                        foregroundColor: Colors.white, 
                        minimumSize: const Size(90, 36), // button size in the bar
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                      ),
                      onPressed: (!canCapture || path.isEmpty)
                          ? null
                          : () async => await deepAr.switchEffect(path),
                      child: Text(title.isEmpty ? 'Effect ${i + 1}' : title),
                    );
                  },
                ),
              ),
            ),
          ),


          _recordTimerOverlay(),

          _zoomOverlay(),

          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: !canCapture || _isVideoLoading
                          ? null
                          : () async {
                              final f = await deepAr.takePhoto();
                              if (f == null) return;
                              setState(() => lastPhoto = f);
                              Navigator.pop(context, {'photo': f.path});
                            },
                      child: const Text('Snap Photo'),
                    ),
                    FilledButton.tonal(
                      style: FilledButton.styleFrom(
                        backgroundColor: _isRecording ? Colors.red : Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: !canCapture || _isVideoLoading
                          ? null
                          : () async {
                              if (_isRecording) {
                                await _stopRecordingAndClearTimer(autoReturn: true);
                              } else {
                                await _startRecordingWithTimer();
                              }
                              if (!mounted) return;
                              setState(() {}); // refresh label/color
                            },
                      child: Text(_isRecording ? 'Stop Rec' : 'Start Rec'),
                    ),
                  ],
                ),
              ),
            ),
          ),

          _loadingOverlay(),
        ],
      ),

      bottomNavigationBar: (lastPhoto == null && lastVideo == null)
      ? null
      : Container(
          color: Colors.black54,
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              if (lastPhoto != null)
                Expanded(
                  child: Text(
                    'Photo: ${lastPhoto!.path}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              if (lastVideo != null)
                Expanded(
                  child: Text(
                    'Video: ${lastVideo!.path}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
        ),
    );
  }
}
