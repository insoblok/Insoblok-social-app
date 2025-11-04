// reaction_video_detail_page.dart
import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insoblok/services/image_service.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:stacked/stacked.dart';
import 'package:video_player/video_player.dart';

import 'package:deepar_flutter_plus/deepar_flutter_plus.dart';
// import 'package:media_kit/media_kit.dart';
// import 'package:pro_video_editor/pro_video_editor.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/deep_ar_plus_service.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';
import 'package:insoblok/services/services.dart';


final kDeeparEffectData = [
  {'title': 'Fire',                'assets': 'assets/effects/filters/fire_effect/Fire_Effect.deepar'},
  {'title': 'Vendetta',            'assets': 'assets/effects/filters/vendetta_mask/Vendetta_Mask.deepar'},
  {'title': 'Flower',              'assets': 'assets/effects/filters/flower_face/flower_face.deepar'},
  {'title': 'Devil Neon Horns',    'assets': 'assets/effects/filters/devil_neon_horns/Neon_Devil_Horns.deepar'},
  {'title': 'Elephant Trunk',      'assets': 'assets/effects/filters/elephant_trunk/Elephant_Trunk.deepar'},
  {'title': 'Emotion Meter',       'assets': 'assets/effects/filters/emotion_meter/Emotion_Meter.deepar'},
  {'title': 'Emotions Exaggerator','assets': 'assets/effects/filters/emotions_exaggerator/Emotions_Exaggerator.deepar'},
  {'title': 'Heart',               'assets': 'assets/effects/filters/heart/8bitHearts.deepar'},
  {'title': 'Hope',                'assets': 'assets/effects/filters/hope/Hope.deepar'},
  {'title': 'Humanoid',            'assets': 'assets/effects/filters/humanoid/Humanoid.deepar'},
  {'title': 'Ping Pong',           'assets': 'assets/effects/filters/ping_pong/Ping_Pong.deepar'},
  {'title': 'Simple',              'assets': 'assets/effects/filters/simple/MakeupLook.deepar'},
  {'title': 'Slipt',               'assets': 'assets/effects/filters/slipt/Split_View_Look.deepar'},
  {'title': 'Snail',               'assets': 'assets/effects/filters/snail/Snail.deepar'},
  {'title': 'Stallone',            'assets': 'assets/effects/filters/stallone/Stallone.deepar'},
  {'title': 'Viking Helmet',       'assets': 'assets/effects/filters/viking_helmet/viking_helmet.deepar'},
];

// single service instance for this page
final _deepAr = DeepArPlusService();

class ReactionVideoDetailPage extends StatefulWidget {
  final String storyID;
  final String url;
  final String videoPath;
  final bool editable;

  const ReactionVideoDetailPage({
    super.key,
    required this.storyID,
    required this.url,
    required this.videoPath,
    required this.editable,
  });

  @override
  State<ReactionVideoDetailPage> createState() => _ReactionVideoDetailPageState();
}

class _ReactionVideoDetailPageState extends State<ReactionVideoDetailPage> {
  String? _selectedEffect;
  File? _editedVideo;                 // <- edited result shown instead of original
  bool _busy = false;

  static const MethodChannel _ch = MethodChannel('deepar_offline');
  static const _androidKey = DEEPAR_ANDROID_KEY;
  static const _iosKey     = DEEPAR_IOS_KEY;

  String get _currentVideoPath => _editedVideo?.path ?? widget.videoPath;
  // final String _currentVideoPath = '/data/data/insoblok.social.app/cache/video_1.mp4';

  @override
  void initState() {
    super.initState();
    _initDeepAr();

    logger.d("This is reaction video detail page. ${widget.videoPath}");
  }

  Future<void> _initDeepAr() async {
    setState(() => _busy = true);
    try {
      await _deepAr.initialize(
        androidKey: _androidKey,
        iosKey: _iosKey,
        resolution: Resolution.medium,
      );
      _selectedEffect = kDeeparEffectData.first['assets']!;
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('AR init failed')),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  // ——— added: open pro_video_editor page and receive exported file ———
  Future<void> _openEditor() async {
    // Ensure native libs are ready (safe to call again)
    // try { MediaKit.ensureInitialized(); } catch (_) {}

    final input = _currentVideoPath;
    if (input.isEmpty || !File(input).existsSync()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Video file missing or unreadable.')),
      );
      return;
    }

    final result = await Navigator.of(context).push<File?>(
      MaterialPageRoute(
        builder: (_) => _VideoQuickEditorPage(inputPath: input),
        fullscreenDialog: true,
      ),
    );

    if (!mounted) return;
    if (result != null && result.existsSync()) {
      setState(() => _editedVideo = result);
    }
  }

  // (optional) your existing DeepAR offline processing kept as-is
  Future<void> _applyFilterToSavedVideo() async {
    final outputPath = await processVideo(
      inputPath: _currentVideoPath,
      androidLicenseKey: _androidKey,
      effectAssetPath: 'assets/effects/filters/fire_effect/Fire_Effect.deepar',
      width: 720,
      height: 1280,
      bitrate: 3 * 1000 * 1000,
      keepAudio: true,
    );
    debugPrint('Filtered video at: $outputPath');
  }

  static Future<String> _copyEffectToCache(String assetPath) async {
    final bytes = await rootBundle.load(assetPath);
    final cache = await getTemporaryDirectory();
    final file = File(p.join(
      cache.path,
      'effect_${assetPath.hashCode}_${DateTime.now().millisecondsSinceEpoch}.deepar',
    ));
    await file.writeAsBytes(bytes.buffer.asUint8List());
    return file.path;
  }

  static Future<String> processVideo({
    required String inputPath,
    required String androidLicenseKey,
    required String effectAssetPath,
    int width = 720,
    int height = 1280,
    int bitrate = 3 * 1000 * 1000,
    bool keepAudio = false,
  }) async {
    final localEffectPath = await _copyEffectToCache(effectAssetPath);
    final tmp = await getTemporaryDirectory();
    final outPath = p.join(tmp.path, 'deepar_out_${DateTime.now().millisecondsSinceEpoch}.mp4');

    final result = await _ch.invokeMethod<String>('processVideo', {
      'input': inputPath,
      'effect': localEffectPath,
      'width': width,
      'height': height,
      'bitrate': bitrate,
      'output': outPath,
      'androidKey': androidLicenseKey,
      'keepAudio': keepAudio,
    });

    if (result == null || result.isEmpty) {
      throw Exception('DeepAR processing failed: empty result');
    }
    return result;
  }

  @override
  void dispose() {
    try { _deepAr.disposeEngine(); } catch (_) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ReactionVideoDetailProvider>.reactive(
      viewModelBuilder: () => ReactionVideoDetailProvider(),
      onViewModelReady: (vm) => vm.init(
        context,
        storyID: widget.storyID,
        url: widget.url,
        videoPath: widget.videoPath,
        editable: widget.editable,
      ),
      builder: (context, vm, _) {
        return Scaffold(
          body: Stack(
            children: [
              // blurred bg (uses your AIImage)
              AIImage(widget.url, width: double.infinity, height: double.infinity),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: (vm.face != null || vm.videoPath.isNotEmpty)
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 24,
                          children: [
                            // annotations (unchanged)
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                spacing: 24,
                                children: [
                                  for (var content in vm.annotations) ...{
                                    Column(
                                      spacing: 4,
                                      children: [
                                        AIImage(content.icon, width: 60, height: 60),
                                        Text(
                                          '${content.title}\n${content.desc}',
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context).textTheme.bodyMedium,
                                        ),
                                      ],
                                    ),
                                  },
                                ],
                              ),
                            ),
                            const SizedBox(height: 40),

                            // player (shows edited output if available)
                            if (File(_currentVideoPath).existsSync())
                              _CircularVideoPlayer(videoPath: _currentVideoPath)
                            else
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Theme.of(context).colorScheme.secondary,
                                    width: 0.5,
                                  ),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(24),
                                  child: AIImage(
                                    vm.face,
                                    fit: BoxFit.contain,
                                    width: MediaQuery.of(context).size.width * 0.7,
                                  ),
                                ),
                              ),

                            const SizedBox(height: 10),

                            // NEW: Edit button
                              FilledButton.icon(
                                onPressed: _openEditor,
                                icon: const Icon(Icons.edit),
                                label: const Text('Edit'),
                              ),

                            const SizedBox(height: 10),

                            // Set / Cancel (unchanged)
                            if (vm.enableEdit)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  FilledButton(
                                    onPressed: _applyFilterToSavedVideo,
                                    style: FilledButton.styleFrom(
                                      minimumSize: const Size(100, 40),
                                    ),
                                    child: const Text('Set'),
                                  ),
                                  const SizedBox(width: 12),
                                  OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      side: const BorderSide(color: Colors.pink, width: 1),
                                      backgroundColor: Colors.transparent,
                                      minimumSize: const Size(100, 40),
                                    ),
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: const Text('Cancel'),
                                  ),
                                ],
                              ),

                            const SizedBox(height: 10),

                            // Reaction buttons (unchanged)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.onSecondary.withAlpha(32),
                                border: Border.all(color: Theme.of(context).primaryColor),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                spacing: 40,
                                children: [
                                  for (var data in kReactionPostIconData) ...{
                                    InkWell(
                                      onTap: () => vm.onClickActionButton(
                                        kReactionPostIconData.indexOf(data),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          AIImage(
                                            data['icon'],
                                            height: 24,
                                            color: Theme.of(context).primaryColor,
                                          ),
                                          Text(
                                            data['title'] as String,
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall
                                                ?.copyWith(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  },
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              ),

              // effects picker (unchanged)
              if (vm.enableEdit)
                SafeArea(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      margin: const EdgeInsets.only(top: 70, right: 8, left: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: SizedBox(
                        height: 44,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          itemCount: kDeeparEffectData.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (context, i) {
                            final item  = kDeeparEffectData[i];
                            final title = (item['title'] ?? '').toString();
                            final path  = (item['assets'] ?? '').toString();
                            final selected = path == _selectedEffect;
                            return FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: selected ? Colors.pink : Colors.white,
                                foregroundColor: selected ? Colors.white : Colors.black,
                                minimumSize: const Size(88, 40),
                              ),
                              onPressed: path.isNotEmpty
                                  ? () => setState(() => _selectedEffect = path)
                                  : null,
                              child: Text(title.isEmpty ? 'Effect ${i + 1}' : title),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),

              const CustomCircleBackButton(),

              if (vm.isBusy)
                Container(
                  color: Colors.black26,
                  child: const Center(child: Loader(size: 60)),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _CircularVideoPlayer extends StatefulWidget {
  final String videoPath;
  const _CircularVideoPlayer({required this.videoPath});

  @override
  State<_CircularVideoPlayer> createState() => _CircularVideoPlayerState();
}

class _CircularVideoPlayerState extends State<_CircularVideoPlayer> {
  late VideoPlayerController _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.videoPath))
      ..initialize().then((_) {
        if (!mounted) return;
        setState(() {
          _initialized = true;
          _controller.setLooping(true);
          _controller.play();
        });
      });
  }

  @override
  void didUpdateWidget(covariant _CircularVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoPath != widget.videoPath) {
      _controller
        ..pause()
        ..dispose();
      _controller = VideoPlayerController.file(File(widget.videoPath))
        ..initialize().then((_) {
          if (!mounted) return;
          setState(() {
            _initialized = true;
            _controller.setLooping(true);
            _controller.play();
          });
        });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width * 0.7;
    return ClipOval(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.secondary,
            width: 2,
          ),
        ),
        child: _initialized
            ? VideoPlayer(_controller)
            : const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
    );
  }
}

/// ─────────────────────────────────────────────────────────────
/// Lightweight editor page using pro_video_editor + media_kit
/// Pops with File on SAVE, or null on cancel
/// ─────────────────────────────────────────────────────────────
class _VideoQuickEditorPage extends StatefulWidget {
  final String inputPath;
  const _VideoQuickEditorPage({required this.inputPath});

  @override
  State<_VideoQuickEditorPage> createState() => _VideoQuickEditorPageState();
}

class _VideoQuickEditorPageState extends State<_VideoQuickEditorPage> {
  VideoPlayerController? _preview;
  Duration _total = Duration.zero;
  Duration _start = Duration.zero;
  Duration _end = Duration.zero;
  bool _mute = false;
  double _speed = 1.0;

  bool _exporting = false;
  double _progress = 0.0;
  // StreamSubscription<ProgressModel>? _sub;

  @override
  void initState() {
    super.initState();
    _initPreview();
  }

  Future<void> _initPreview() async {
    try {
      if (widget.inputPath.isEmpty || !File(widget.inputPath).existsSync()) {
        throw Exception('Video file missing or unreadable.');
      }
      final ctrl = VideoPlayerController.file(File(widget.inputPath));
      await ctrl.initialize();
      if (!mounted) return;

      final d = ctrl.value.duration;
      setState(() {
        _preview = ctrl;
        _total  = (d.inMilliseconds <= 0) ? const Duration(milliseconds: 500) : d;
        _start  = Duration.zero;
        _end    = _total;
      });

      _preview!
        ..setLooping(true)
        ..play();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cannot open editor: $e')),
      );
      Navigator.of(context).pop<File?>(null);
    }
  }

  @override
  void dispose() {
    // _sub?.cancel();
    _preview?.dispose();
    super.dispose();
  }

  Future<void> _export() async {
    if (_exporting) return;
    setState(() {
      _exporting = true;
      _progress = 0;
    });

    try {
      final tmp = await getTemporaryDirectory();
      final outPath = p.join(tmp.path, 'edited_${DateTime.now().millisecondsSinceEpoch}.mp4');

      // Clamp
      final total = _total.inMilliseconds <= 0 ? const Duration(milliseconds: 500) : _total;
      final s = _start < Duration.zero ? Duration.zero : _start;
      final e = _end > total ? total : _end;
      final startClamped = s > e ? Duration.zero : s;
      final endClamped   = e < startClamped ? null : e;

      // final model = RenderVideoModel(
      //   id: 'task_${DateTime.now().millisecondsSinceEpoch}',
      //   video: EditorVideo.file(File(widget.inputPath)),
      //   outputFormat: VideoOutputFormat.mp4,
      //   enableAudio: !_mute,
      //   playbackSpeed: _speed,
      //   startTime: startClamped,
      //   endTime: endClamped,
      //   bitrate: 3 * 1000 * 1000,
      // );

      // final taskId = await ProVideoEditor.instance.renderVideoToFile(outPath, model);

      /*
      _sub?.cancel();
      _sub = ProVideoEditor.instance.progressStreamById(taskId).listen(
        (p) => setState(() => _progress = p.progress.clamp(0, 1)),
        onDone: () async {
          _sub?.cancel(); _sub = null;
          setState(() => _exporting = false);
          final f = File(outPath);
          if (await f.exists()) {
            if (!mounted) return;
            Navigator.of(context).pop<File>(f);
          } else {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Export failed')),
            );
          }
        },
        onError: (e) {
          setState(() => _exporting = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Export error: $e')),
          );
        },
      );
      */
    } catch (e) {
      setState(() => _exporting = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Export failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalMs = _total.inMilliseconds.toDouble();
    final safeMax = (totalMs.isFinite && totalMs > 0) ? totalMs : 500.0;

    double startMs = _start.inMilliseconds.toDouble();
    double endMs   = _end.inMilliseconds.toDouble();

    if (!startMs.isFinite || startMs < 0) startMs = 0;
    if (!endMs.isFinite   || endMs   < 0) endMs   = 0;
    if (startMs > endMs) startMs = endMs;
    if (startMs == endMs) endMs = (startMs + 1).clamp(0, safeMax);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Video'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop<File?>(null),
        ),
        actions: [
          TextButton(
            onPressed: _exporting ? null : _export,
            child: const Text('SAVE'),
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              AspectRatio(
                aspectRatio: (_preview?.value.isInitialized ?? false)
                    ? _preview!.value.aspectRatio
                    : 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: (_preview?.value.isInitialized ?? false)
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: VideoPlayer(_preview!),
                        )
                      : const Center(child: CircularProgressIndicator()),
                ),
              ),
              const SizedBox(height: 16),

              Text('Trim', style: Theme.of(context).textTheme.titleMedium),

              RangeSlider(
                min: 0.0,
                max: safeMax,
                values: RangeValues(startMs, endMs),
                onChanged: (v) {
                  final s = Duration(milliseconds: v.start.round());
                  final e = Duration(milliseconds: v.end.round());
                  setState(() {
                    _start = (e < s) ? Duration(milliseconds: v.end.round()) : s;
                    _end   = (e < s) ? Duration(milliseconds: v.end.round()) : e;
                  });
                },
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_fmt(Duration(milliseconds: startMs.round()))),
                  Text(_fmt(Duration(milliseconds: endMs.round()))),
                ],
              ),
              const SizedBox(height: 16),

              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Mute audio'),
                value: _mute,
                onChanged: (v) => setState(() => _mute = v),
              ),
              const SizedBox(height: 8),

              Text('Playback speed: ${_speed.toStringAsFixed(2)}x',
                  style: Theme.of(context).textTheme.titleMedium),
              Slider(
                min: 0.25,
                max: 2.0,
                divisions: 7,
                value: _speed,
                onChanged: (v) => setState(() => _speed = v),
              ),
            ],
          ),

          if (_exporting)
            Container(
              color: Colors.black38,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: 52,
                      height: 52,
                      child: CircularProgressIndicator(strokeWidth: 4),
                    ),
                    const SizedBox(height: 12),
                    Text('Exporting ${(_progress * 100).toStringAsFixed(0)}%'),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _fmt(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return h > 0 ? '$h:$m:$s' : '$m:$s';
  }
}
