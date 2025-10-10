// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_code_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AccessCodeModel _$AccessCodeModelFromJson(Map<String, dynamic> json) =>
    _AccessCodeModel(
      userId: json['userId'] as String?,
      accessCode: json['accessCode'] as String?,
      expiry: json['expiry'] as bool?,
      checked: json['checked'] as bool?,
      createdAt:
          json['createdAt'] == null
              ? null
              : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$AccessCodeModelToJson(_AccessCodeModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'accessCode': instance.accessCode,
      'expiry': instance.expiry,
      'checked': instance.checked,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
