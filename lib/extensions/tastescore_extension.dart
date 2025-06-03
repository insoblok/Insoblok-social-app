import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';

extension TastescoreModelExt on TastescoreModel {
  Map<String, dynamic> toMap() {
    return toJson().toFirebaseJson;
  }
}

extension ConnectedStoryModelExt on ConnectedStoryModel {
  Map<String, dynamic> toMap() {
    return toJson().toFirebaseJson;
  }
}
