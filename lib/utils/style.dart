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

BoxDecoration get kCardDecoration => BoxDecoration(
  borderRadius: BorderRadius.circular(16.0),
  border: Border.all(width: 0.66, color: AIColors.pink),
);

BoxDecoration get kNoBorderDecoration => BoxDecoration(
  border: Border.all(width: 0.75, color: AIColors.pink),
  borderRadius: BorderRadius.circular(24.0),
);

BoxDecoration get kTextFieldDecoration => BoxDecoration(
  border: Border.all(width: 0.66, color: AIColors.pink),
  borderRadius: BorderRadius.circular(24.0),
);
