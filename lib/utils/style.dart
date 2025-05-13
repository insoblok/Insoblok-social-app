import 'package:flutter/material.dart';

import 'package:insoblok/services/services.dart';
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
  color: AppSettingHelper.background,
  borderRadius: BorderRadius.circular(16.0),
  border: Border.all(width: 0.33, color: AIColors.pink),
);

BoxDecoration kNoBorderDecoration = BoxDecoration(
  border: Border.all(width: 0.33, color: AIColors.pink),
  borderRadius: BorderRadius.circular(24.0),
);
