// reaction_video_detail_page.dart
import 'dart:io';
import 'dart:math' as logger;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insoblok/services/image_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stacked/stacked.dart';
import 'package:video_player/video_player.dart';

import 'package:deepar_flutter_plus/deepar_flutter_plus.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/deep_ar_plus_service.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';
import 'package:path/path.dart' as p;

final kDeeparEffectData = [
  {'title': 'Fire',               'assets': 'assets/effects/filters/fire_effect/Fire_Effect.deepar'},
  {'title': 'Vendetta',           'assets': 'assets/effects/filters/vendetta_mask/Vendetta_Mask.deepar'},
  {'title': 'Flower',             'assets': 'assets/effects/filters/flower_face/flower_face.deepar'},
  {'title': 'Devil Neon Horns',   'assets': 'assets/effects/filters/devil_neon_horns/Neon_Devil_Horns.deepar'},
  {'title': 'Elephant Trunk',     'assets': 'assets/effects/filters/elephant_trunk/Elephant_Trunk.deepar'},
  {'title': 'Emotion Meter',      'assets': 'assets/effects/filters/emotion_meter/Emotion_Meter.deepar'},
  {'title': 'Emotions Exaggerator','assets':'assets/effects/filters/emotions_exaggerator/Emotions_Exaggerator.deepar'},
  {'title': 'Heart',              'assets': 'assets/effects/filters/heart/8bitHearts.deepar'},
  {'title': 'Hope',               'assets': 'assets/effects/filters/hope/Hope.deepar'},
  {'title': 'Humanoid',           'assets': 'assets/effects/filters/humanoid/Humanoid.deepar'},
  {'title': 'Ping Pong',          'assets': 'assets/effects/filters/ping_pong/Ping_Pong.deepar'},
  {'title': 'Simple',             'assets': 'assets/effects/filters/simple/MakeupLook.deepar'},
  {'title': 'Slipt',              'assets': 'assets/effects/filters/slipt/Split_View_Look.deepar'},
  {'title': 'Snail',              'assets': 'assets/effects/filters/snail/Snail.deepar'},
  {'title': 'Stallone',           'assets': 'assets/effects/filters/stallone/Stallone.deepar'},
  {'title': 'Viking Helmet',      'assets': 'assets/effects/filters/viking_helmet/viking_helmet.deepar'},
];

// Keep a single service instance for the page
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
  String? _selectedEffect;       // asset path currently selected
  File? _filteredVideo;          // output from export (when implemented)
  bool _busy = false;            // local spinner

  static const MethodChannel _ch = MethodChannel('deepar_offline');
  
  static const _androidKey = DEEPAR_ANDROID_KEY;
  static const _iosKey     = DEEPAR_IOS_KEY;

  String get _effectiveVideoPath => _filteredVideo?.path ?? widget.videoPath;

  @override
  void initState() {
    super.initState();
    _initDeepAr();
  }

  Future<void> _initDeepAr() async {
    setState(() => _busy = true);
    try {
      await _deepAr.initialize(
        androidKey: _androidKey,
        iosKey: _iosKey,
        resolution: Resolution.medium,
      );
      // set a default effect
      _selectedEffect = kDeeparEffectData.first['assets']!;
      await _switchEffect(_selectedEffect!);
    } catch (e, s) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('AR init failed')),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _switchEffect(String assetPath) async {
    // if (!_deepAr.isReady) return;
    // setState(() => _busy = true);
    // try {
    //   final localPath = await _deepAr.loadEffectFromAssets(assetPath);
    //   await _deepAr.switchEffect(localPath);
    //   _selectedEffect = assetPath;
    // } catch (e) {

    // } finally {
    //   if (mounted) setState(() => _busy = false);
    // }
  }

  Future<void> _applyFilterToSavedVideo() async {
    final outputPath = await processVideo(
      inputPath: '/data/user/0/insoblok.social.app/cache/SnapVideo.MOV',
      androidLicenseKey: _androidKey,
      effectAssetPath: 'assets/effects/filters/fire_effect/Fire_Effect.deepar',
      width: 720,
      height: 1280,
      bitrate: 3 * 1000 * 1000,
      keepAudio: true, // optional: try to keep original audio (see note)
    );

    // use outputPath (e.g., play or upload it)
    print('Filtered video at: $outputPath');
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
    required String effectAssetPath, // e.g. assets/effects/filters/flower_face/flower_face.deepar
    int width = 720,
    int height = 1280,
    int bitrate = 3 * 1000 * 1000,
    bool keepAudio = false, // optional: try remux original audio
  }) async {
    // copy effect to local file path
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
    _deepAr.disposeEngine();
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
              // Blurred BG
              AIImage(widget.url, width: double.infinity, height: double.infinity),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: (vm.face != null || vm.videoPath.isNotEmpty)
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 24,
                          children: [
                            // Annotations
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

                            // Circular player (use filtered path if present)
                            if (File(_effectiveVideoPath).existsSync())
                              _CircularVideoPlayer(videoPath: _effectiveVideoPath)
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

                            // Set / Cancel
                            if(vm.enableEdit)
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

                            // Reaction buttons
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

              // Effects picker (top-right)
              if(vm.enableEdit)
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
                              onPressed: (_deepAr.isReady && path.isNotEmpty)
                                  ? () => _switchEffect(path)
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

              if (vm.isBusy || _busy)
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
        child: VideoPlayer(_controller)
           
      ),
    );
  }
}
