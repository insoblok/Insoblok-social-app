import 'package:flutter/material.dart';
import 'package:deepar_flutter_plus/deepar_flutter_plus.dart';
import 'package:insoblok/services/deep_ar_plus_service.dart';

class DeepArPlusSurface extends StatelessWidget {
  const DeepArPlusSurface({
    super.key,
    required this.service,
    this.scale,
    this.offstage = false,
  });

  final DeepArPlusService service;
  final double? scale;    // e.g., service.aspectRatio * 1.3 (like your sample)
  final bool offstage;    // set true to keep engine running but hide the view

  @override
  Widget build(BuildContext context) {
    if (!service.isReady) {
      return const Center(child: CircularProgressIndicator());
    }

    Widget preview = DeepArPreviewPlus(service.controller);
    if (scale != null) {
      preview = Transform.scale(scale: scale!, child: preview);
    }

    return offstage ? Offstage(offstage: true, child: preview) : preview;
  }
}