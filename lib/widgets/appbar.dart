import 'package:flutter/material.dart';

const kCustomAppbarHeight = 45.0;
const kExtendAppbarHeight = 45.0;

class AISliverAppbar extends SliverAppBar {
  AISliverAppbar(
    BuildContext context, {
    double? extendHeight,
    Widget? extendWidget,
    super.key,
    super.pinned,
    super.floating,
    super.leading,
    super.title,
    super.actions,
  }) : super(
         expandedHeight:
             extendWidget != null
                 ? kCustomAppbarHeight +
                     (extendHeight ?? kExtendAppbarHeight) +
                     10.0
                 : null,
         elevation: 1.0,
         centerTitle: true,
         flexibleSpace:
             extendWidget != null
                 ? FlexibleSpaceBar(
                   collapseMode: CollapseMode.none,
                   background: Container(
                     margin: EdgeInsets.only(
                       top:
                           (extendHeight ?? kExtendAppbarHeight) +
                           MediaQuery.of(context).padding.top +
                           10.0,
                     ),
                     padding: const EdgeInsets.symmetric(horizontal: 20.0),
                     height: (extendHeight ?? kExtendAppbarHeight),
                     child: extendWidget,
                   ),
                 )
                 : null,
       );
}

class AIPersistentHeader extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double maxSize;
  final double minSize;
  final dynamic dynamicValue;

  AIPersistentHeader({
    required this.child,
    required this.maxSize,
    required this.minSize,
    this.dynamicValue,
  });

  @override
  double get maxExtent => maxSize;

  @override
  double get minExtent => minSize;

  @override
  Widget build(BuildContext context, shrinkOffset, overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(AIPersistentHeader oldDelegate) {
    if (oldDelegate.maxSize == 0) return false;
    if (oldDelegate.maxExtent != maxSize) return true;
    if (oldDelegate.dynamicValue != dynamicValue) return true;
    return false;
  }
}
