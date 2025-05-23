import 'package:flutter/material.dart';
import 'package:insoblok/utils/color.dart';

class TagView extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? borderColor;
  final Color? backGroundColor;
  final String tag;
  final bool isSelected;
  final void Function()? onTap;

  const TagView({
    super.key,
    required this.tag,
    required this.isSelected,
    this.width,
    this.height,
    this.borderColor,
    this.backGroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        height: height ?? 36,

        decoration: BoxDecoration(
          color: isSelected ? backGroundColor ?? AIColors.pink : AIColors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            width: 2.0,
            color:
                isSelected
                    ? AIColors.transparent
                    : borderColor ?? AIColors.pink,
          ),
        ),
        child: Text(
          tag,
          style: TextStyle(
            color: isSelected ? AIColors.white : AIColors.pink,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }
}
