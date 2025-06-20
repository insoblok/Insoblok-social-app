import 'package:flutter/material.dart';

import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class InSoBlokEmptyView extends StatelessWidget {
  final String desc;

  const InSoBlokEmptyView({super.key, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Column(
          spacing: 24.0,
          mainAxisSize: MainAxisSize.min,
          children: [
            AIImage(
              AIImages.imgEmptyList,
              width: 80.0,
              height: 80.0,
              fit: BoxFit.contain,
            ),
            Text(desc, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
