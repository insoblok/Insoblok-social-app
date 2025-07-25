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

class AppBackgroundView extends StatelessWidget {
  final Widget? child;
  final double? height;
  const AppBackgroundView({super.key, this.child, this.height});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AIColors.lightPurple.withAlpha(32),
              AIColors.lightBlue.withAlpha(32),
              AIColors.lightPurple.withAlpha(32),
              AIColors.lightTeal.withAlpha(32),
            ],
            stops: [0.0, 0.4, 0.7, 1.0],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: child,
      ),
    );
  }
}

class BottomBarBackgroundView extends StatelessWidget {
  final Widget? child;
  final double? height;
  const BottomBarBackgroundView({super.key, this.child, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: child,
    );
  }
}

class AIBottomBar extends StatelessWidget {
  final String icon;
  final Color? color;
  final String? label;
  final void Function()? onTap;
  const AIBottomBar({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        spacing: 4.0,
        children: [
          AIImage(
            icon,
            width: 18.0,
            height: 18.0,
            color: color ?? AIColors.white,
          ),
          Text(
            label ?? '',
            style: TextStyle(fontSize: 12, color: color ?? AIColors.white),
          ),
        ],
      ),
    );
  }
}
