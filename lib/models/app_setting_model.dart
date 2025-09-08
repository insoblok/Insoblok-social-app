import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_setting_model.freezed.dart';
part 'app_setting_model.g.dart';

@freezed
abstract class AppSettingModel with _$AppSettingModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory AppSettingModel({
    List<AboutAppModel>? abouts,
    List<XpEarnModel>? xpEarn,
    List<XpInSoModel>? xpInso,
    List<UserLevelModel>? userLevel,
  }) = _AppSettingModel;

  factory AppSettingModel.fromJson(Map<String, dynamic> json) =>
      _$AppSettingModelFromJson(json);
}

@freezed
abstract class AboutAppModel with _$AboutAppModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory AboutAppModel({String? title, String? description}) = _AboutAppModel;

  factory AboutAppModel.fromJson(Map<String, dynamic> json) =>
      _$AboutAppModelFromJson(json);
}

@freezed
abstract class XpEarnModel with _$XpEarnModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory XpEarnModel({
    String? key,
    String? name,
    String? bonusDecription,
    int? reward,
    double? bonus,
  }) = _XpEarnModel;

  factory XpEarnModel.fromJson(Map<String, dynamic> json) =>
      _$XpEarnModelFromJson(json);
}

@freezed
abstract class XpInSoModel with _$XpInSoModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory XpInSoModel({int? min, int? max, int? inso, int? rate}) = _XpInSoModel;

  factory XpInSoModel.fromJson(Map<String, dynamic> json) =>
      _$XpInSoModelFromJson(json);

}

@freezed
abstract class UserLevelModel with _$UserLevelModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory UserLevelModel({
    int? level,
    String? title,
    int? min,
    int? max,
    List<String>? feature,
  }) = _UserLevelModel;

  factory UserLevelModel.fromJson(Map<String, dynamic> json) =>
      _$UserLevelModelFromJson(json);
}
