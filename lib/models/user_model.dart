import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:insoblok/services/services.dart';

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
    DateTime? updateDate,
    DateTime? timestamp,
    String? status,
    int? rewardDate,
    List<String>? likes,
    List<String>? follows,
    List<UserActionModel>? actions,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(FirebaseHelper.fromConvertJson(json));
}

@freezed
abstract class UserActionModel with _$UserActionModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory UserActionModel({
    String? postUid,
    String? userUid,
    bool? value,
    String? type,
    String? description,
    DateTime? timestamp,
  }) = _UserActionModel;

  factory UserActionModel.fromJson(Map<String, dynamic> json) =>
      _$UserActionModelFromJson(FirebaseHelper.fromConvertJson(json));
}

@freezed
abstract class UserCountryModel with _$UserCountryModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory UserCountryModel({String? name, String? code}) = _UserCountryModel;
  factory UserCountryModel.fromJson(Map<String, dynamic> json) =>
      _$UserCountryModelFromJson(json);
}
