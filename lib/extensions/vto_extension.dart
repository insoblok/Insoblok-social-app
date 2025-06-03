import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';

extension VTOCellModelExt on VTOCellModel {
  Map<String, dynamic> toMap() {
    Map<String, dynamic> result = {
      'title': title,
      'image': image,
      'desc': desc,
    };
    result.removeWhere((k, v) => v == null);
    return result;
  }
}

extension VTOGroupModelExt on VTOGroupModel {
  Map<String, dynamic> toMap() {
    Map<String, dynamic> result = {
      'name': name,
      'list': ((list ?? []).map((e) => e.toMap()).toList()),
    };
    result.removeWhere((k, v) => v == null);
    return result;
  }
}
