// deep_ar_plus_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:deepar_flutter_plus/deepar_flutter_plus.dart';

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await deepAr.initialize(
        androidKey: 'e332c29bc405ace300d31b356060ee1b3604fe96e7ef3cb47d3f16d7fedd9e626f00f88acb70aedd',
        iosKey: '5dd0e1f500e57133ea528acbc4fba42d38c80229590d1fdab9dfcb07145c0f9ccb9bb2bcc5bc5262',
        resolution: Resolution.medium,
        initialEffect: 'assets/effects/filters/fire_effect/Fire_Effect.deepar',
      );
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    deepAr.disposeEngine();
    super.dispose();
  }

  void _finishAndReturn() {
    Navigator.of(context).pop(<String, String?>{
      'photo': lastPhoto?.path,
      'video': lastVideo?.path,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DeepAR Camera'),
        actions: [
          TextButton(
            onPressed: _finishAndReturn,
            child: const Text('Done'),
          ),
        ],
      ),
      body: Stack(
        children: [
          // 1) AR preview
          Positioned.fill(
            child: DeepArPlusSurface(
              service: deepAr,
              scale: deepAr.aspectRatio * 1.3,
            ),
          ),

          // 2) Effects list
          ListView.builder(
            padding: const EdgeInsets.only(top: 30, left: 4, right: 4, bottom: 4),
            itemCount: kDeeparEffectData.length,
            itemBuilder: (context, i) {
              final item = kDeeparEffectData[i];
              final title = (item['title'] ?? '').toString();
              final path  = (item['assets'] ?? '').toString();

              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton(
                    onPressed: (!deepAr.isReady || path.isEmpty)
                        ? null
                        : () async => await deepAr.switchEffect(path),
                    child: Text(title.isEmpty ? 'Effect ${i + 1}' : title),
                  ),
                ),
              );
            },
          ),

          // 3) Capture controls
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Wrap(
                  spacing: 12, runSpacing: 12, alignment: WrapAlignment.center,
                  children: [
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () async {
                        final f = await deepAr.takePhoto();
                        if (f == null) return;
                        setState(() => lastPhoto = f);

                        // If you prefer to return immediately after snapping:
                        Navigator.pop(context, {'photo': f.path});
                      },
                      child: const Text('Snap Photo'),
                    ),
                    FilledButton.tonal(
                      style: FilledButton.styleFrom(
                        backgroundColor: deepAr.isRecording ? Colors.red : Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () async {
                        final result = await deepAr.toggleRecording();
                        if (!mounted) return;
                        setState(() {}); // refresh label/color
                        if (result != null) {
                          setState(() => lastVideo = result);

                          // If you prefer to return immediately after stopping:
                          Navigator.pop(context, {'video': result.path});
                        }
                      },
                      child: Text(deepAr.isRecording ? 'Stop Rec' : 'Start Rec'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      // Optional: quick peek
      bottomNavigationBar: (lastPhoto == null && lastVideo == null)
          ? null
          : Container(
              color: Colors.black54,
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  if (lastPhoto != null)
                    Expanded(child: Text('Photo: ${lastPhoto!.path}', maxLines: 1, overflow: TextOverflow.ellipsis)),
                  if (lastVideo != null)
                    Expanded(child: Text('Video: ${lastVideo!.path}', maxLines: 1, overflow: TextOverflow.ellipsis)),
                ],
              ),
            ),
    );
  }
}
