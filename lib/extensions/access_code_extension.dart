import 'package:flutter/material.dart';

import 'package:gradient_borders/box_borders/gradient_box_border.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

extension AccessCodeExtension on AccessCodeModel {
  Map<String, dynamic> toMap() {
    Map<String, dynamic> result = {
      "email": email,
      "user_id": userId,
      "birthday": birthday,
      'access_code': accessCode,
      'expiry': expiry,
      'created_at': createdAt
    };
    result.removeWhere((k, v) => v == null);
    return result;
  }
}