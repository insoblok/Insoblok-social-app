import 'package:freezed_annotation/freezed_annotation.dart';

part 'access_code_model.freezed.dart';
part 'access_code_model.g.dart';

@freezed
abstract class AccessCodeModel with _$AccessCodeModel {
  factory AccessCodeModel({
    String? userId,
    String? accessCode,
    bool? expiry,
    bool? checked,
    DateTime? createdAt,
  }) = _AccessCodeModel;

  factory AccessCodeModel.fromJson(Map<String, dynamic> json) =>
      _$AccessCodeModelFromJson(json);
}
