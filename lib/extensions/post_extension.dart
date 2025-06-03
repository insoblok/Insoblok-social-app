import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';

extension PostExtension on PostModel {
  Map<String, dynamic> toMap() {
    return toJson().toFirebaseJson;
  }
}
