// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_setting_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppSettingModel _$AppSettingModelFromJson(Map<String, dynamic> json) =>
    _AppSettingModel(
      abouts: (json['abouts'] as List<dynamic>?)
          ?.map((e) => AboutAppModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      xpEarn: (json['xp_earn'] as List<dynamic>?)
          ?.map((e) => XpEarnModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      xpInso: (json['xp_inso'] as List<dynamic>?)
          ?.map((e) => XpInSoModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      userLevel: (json['user_level'] as List<dynamic>?)
          ?.map((e) => UserLevelModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AppSettingModelToJson(_AppSettingModel instance) =>
    <String, dynamic>{
      'abouts': instance.abouts,
      'xp_earn': instance.xpEarn,
      'xp_inso': instance.xpInso,
      'user_level': instance.userLevel,
    };

_AboutAppModel _$AboutAppModelFromJson(Map<String, dynamic> json) =>
    _AboutAppModel(
      title: json['title'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$AboutAppModelToJson(_AboutAppModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
    };

_XpEarnModel _$XpEarnModelFromJson(Map<String, dynamic> json) => _XpEarnModel(
      key: json['key'] as String?,
      name: json['name'] as String?,
      bonusDecription: json['bonus_decription'] as String?,
      reward: (json['reward'] as num?)?.toInt(),
      bonus: (json['bonus'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$XpEarnModelToJson(_XpEarnModel instance) =>
    <String, dynamic>{
      'key': instance.key,
      'name': instance.name,
      'bonus_decription': instance.bonusDecription,
      'reward': instance.reward,
      'bonus': instance.bonus,
    };

_XpInSoModel _$XpInSoModelFromJson(Map<String, dynamic> json) => _XpInSoModel(
      min: (json['min'] as num?)?.toInt(),
      max: (json['max'] as num?)?.toInt(),
      rate: (json['rate'] as num?)?.toInt(),
    );

Map<String, dynamic> _$XpInSoModelToJson(_XpInSoModel instance) =>
    <String, dynamic>{
      'min': instance.min,
      'max': instance.max,
      'rate': instance.rate,
    };

_UserLevelModel _$UserLevelModelFromJson(Map<String, dynamic> json) =>
    _UserLevelModel(
      level: (json['level'] as num?)?.toInt(),
      title: json['title'] as String?,
      min: (json['min'] as num?)?.toInt(),
      max: (json['max'] as num?)?.toInt(),
      feature:
          (json['feature'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$UserLevelModelToJson(_UserLevelModel instance) =>
    <String, dynamic>{
      'level': instance.level,
      'title': instance.title,
      'min': instance.min,
      'max': instance.max,
      'feature': instance.feature,
    };
