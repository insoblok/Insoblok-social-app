import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory UserModel({
    int? id,
    String? address,
    String? avatar,
    String? firstName,
    String? lastName,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
