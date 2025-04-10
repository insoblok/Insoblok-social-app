// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MessageModel _$MessageModelFromJson(Map<String, dynamic> json) =>
    _MessageModel(
      id: json['id'] as String?,
      senderId: json['sender_id'] as String?,
      content: json['content'] as String?,
      url: json['url'] as String?,
      type: json['type'] as String?,
      regDate: json['reg_date'] as String?,
      updateDate: json['update_date'] as String?,
    );

Map<String, dynamic> _$MessageModelToJson(_MessageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sender_id': instance.senderId,
      'content': instance.content,
      'url': instance.url,
      'type': instance.type,
      'reg_date': instance.regDate,
      'update_date': instance.updateDate,
    };
