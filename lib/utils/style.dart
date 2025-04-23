import 'package:flutter/material.dart';

import 'package:insoblok/utils/utils.dart';

List<BoxShadow> kContainerDarkShadow = [
  BoxShadow(
    blurRadius: 5.0,
    color: AIColors.shadowDarkColor,
    offset: Offset(2, 2),
  ),
  BoxShadow(
    blurRadius: 5.0,
    color: AIColors.shadowLightColor,
    offset: Offset(-2, -2),
  ),
];

BoxDecoration kCardDecoration = BoxDecoration(
  color: AIColors.darkScaffoldBackground,
  borderRadius: BorderRadius.circular(16.0),
  boxShadow: kContainerDarkShadow,
);
