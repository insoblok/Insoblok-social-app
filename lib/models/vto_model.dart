import 'package:freezed_annotation/freezed_annotation.dart';

part 'vto_model.freezed.dart';
part 'vto_model.g.dart';

@freezed
abstract class VTOCellModel with _$VTOCellModel {
  factory VTOCellModel({String? title, String? image, String? desc}) =
      _VTOCellModel;
  factory VTOCellModel.fromJson(Map<String, dynamic> json) =>
      _$VTOCellModelFromJson(json);
}

@freezed
abstract class VTOGroupModel with _$VTOGroupModel {
  factory VTOGroupModel({String? name, List<VTOCellModel>? list}) =
      _VTOGroupModel;
  factory VTOGroupModel.fromJson(Map<String, dynamic> json) =>
      _$VTOGroupModelFromJson(json);
}
