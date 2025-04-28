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
                           MediaQuery.of(context).viewInsets.top +
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
