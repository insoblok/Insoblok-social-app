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
    String? email,
    String? password,
    String? city,
    String? country,
    String? website,
    String? desc,
    String? discovery,
    String? nickId,
    double? lat,
    double? lon,
    String? ipAddress,
    String? regdate,
    String? timestamp,
    String? status,
    List<String>? likes,
    List<String>? follows,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

@freezed
abstract class UserCountryModel with _$UserCountryModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory UserCountryModel({String? name, String? code}) = _UserCountryModel;
  factory UserCountryModel.fromJson(Map<String, dynamic> json) =>
      _$UserCountryModelFromJson(json);
}
