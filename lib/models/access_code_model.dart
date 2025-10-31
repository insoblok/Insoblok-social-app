import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:insoblok/services/services.dart';

part 'access_code_model.freezed.dart';
part 'access_code_model.g.dart';

@freezed
abstract class AccessCodeModel with _$AccessCodeModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory AccessCodeModel({
    String? id,
    String? email,
    String? userId,
    DateTime? birthday,
    String? accessCode,
    bool? expiry,
    bool? checked,
    DateTime? createdAt,
  }) = _AccessCodeModel;  

  factory AccessCodeModel.fromJson(Map<String, dynamic> json) =>
      _$AccessCodeModelFromJson(FirebaseHelper.fromConvertJson(json));

  
}
