import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';

extension PostExtension on PostModel {
  Map<String, dynamic> toMap() {
    Map<String, dynamic> result = {
      'uid': uid,
      'media': media?.toMap(),
      'timestamp': timestamp?.toUtc().toIso8601String(),
    };
    result.removeWhere((k, v) => v == null);
    return result;
  }
}
