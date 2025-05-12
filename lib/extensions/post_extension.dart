import 'package:insoblok/models/models.dart';

extension PostExtension on PostModel {
  Map<String, dynamic> toMap() {
    return {'uid': uid, 'media': media?.toJson()};
  }
}
