import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory UserModel({
    String? id,
    String? uid,
    String? walletAddress,
    String? avatar,
    String? firstName,
    String? lastName,
    double? lat,
    double? lon,
    String? ipAddress,
    String? regdate,
    String? updateDate,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
