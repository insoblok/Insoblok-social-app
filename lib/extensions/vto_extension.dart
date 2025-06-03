import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';

extension VTOCellModelExt on VTOCellModel {
  Map<String, dynamic> toMap() {
    return toJson().toFirebaseJson;
  }
}

extension VTOGroupModelExt on VTOGroupModel {
  Map<String, dynamic> toMap() {
    return toJson().toFirebaseJson;
  }
}
