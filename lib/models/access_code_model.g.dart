// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_code_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AccessCodeModel _$AccessCodeModelFromJson(Map<String, dynamic> json) =>
    _AccessCodeModel(
      id: json['id'] as String?,
      email: json['email'] as String?,
      userId: json['user_id'] as String?,
      birthday:
          json['birthday'] == null
              ? null
              : DateTime.parse(json['birthday'] as String),
      accessCode: json['access_code'] as String?,
      expiry: json['expiry'] as bool?,
      checked: json['checked'] as bool?,
      createdAt:
          json['created_at'] == null
              ? null
              : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$AccessCodeModelToJson(_AccessCodeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'user_id': instance.userId,
      'birthday': instance.birthday?.toIso8601String(),
      'access_code': instance.accessCode,
      'expiry': instance.expiry,
      'checked': instance.checked,
      'created_at': instance.createdAt?.toIso8601String(),
    };
