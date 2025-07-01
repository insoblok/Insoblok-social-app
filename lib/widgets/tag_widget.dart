import 'package:flutter/material.dart';
import 'package:insoblok/utils/color.dart';

class TagView extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? borderColor;
  final Color? backGroundColor;
  final String tag;
  final double? textSize;
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
    this.textSize,
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
            width: 1.0,
            color:
                isSelected
                    ? AIColors.transparent
                    : borderColor ?? AIColors.pink,
          ),
        ),
        child: Center(
          child: Text(
            tag,
            style: TextStyle(
              color: isSelected ? AIColors.white : AIColors.pink,
              fontSize: textSize ?? 12.0,
            ),
          ),
        ),
      ),
    );
  }
}

class TabCoverView extends StatelessWidget {
  final String title;
  final bool selected;
  final double? width;
  final void Function()? onTap;

  const TabCoverView(
    this.title, {
    super.key,
    required this.selected,
    this.width,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(vertical: 8.0),

        decoration: BoxDecoration(
          border:
              selected
                  ? Border(bottom: BorderSide(width: 2.0, color: AIColors.pink))
                  : null,
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style:
              selected
                  ? Theme.of(context).textTheme.headlineSmall
                  : Theme.of(context).textTheme.labelMedium,
        ),
      ),
    );
  }
}
