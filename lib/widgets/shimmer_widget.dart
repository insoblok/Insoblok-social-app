import 'package:flutter/material.dart';

import 'package:shimmer/shimmer.dart';

class ShimmerContainer extends StatelessWidget {
  final Widget child;
  const ShimmerContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      period: const Duration(milliseconds: 1000),
      child: child,
    );
  }
}
