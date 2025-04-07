import 'package:flutter/material.dart';
import 'package:insoblok/services/image_service.dart';

import 'package:insoblok/utils/utils.dart';

class OutlineButton extends StatelessWidget {
  final double? width;
  final double? height;
  final Widget child;
  final Color? borderColor;
  final bool isBusy;
  final void Function()? onTap;

  const OutlineButton({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.borderColor,
    this.onTap,
    this.isBusy = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 52.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            width: 2.0,
            color: borderColor ?? AIColors.borderColor,
          ),
        ),
        alignment: Alignment.center,
        child: isBusy
            ? Center(
                child: Loader(
                  color: borderColor,
                  size: 28.0,
                ),
              )
            : child,
      ),
    );
  }
}
