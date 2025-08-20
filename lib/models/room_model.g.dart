// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RoomModel _$RoomModelFromJson(Map<String, dynamic> json) => _RoomModel(
  id: json['id'] as String?,
  userId: json['user_id'] as String?,
  userIds:
      (json['user_ids'] as List<dynamic>?)?.map((e) => e as String?).toList(),
  updateDate:
      json['update_date'] == null
          ? null
          : DateTime.parse(json['update_date'] as String),
  timestamp:
      json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
  content: json['content'] as String?,
  statusSender: json['status_sender'] as String?,
  statusReceiver: json['status_receiver'] as String?,
  isGroup: json['is_group'] as bool?,
);

Map<String, dynamic> _$RoomModelToJson(_RoomModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'user_ids': instance.userIds,
      'update_date': instance.updateDate?.toIso8601String(),
      'timestamp': instance.timestamp?.toIso8601String(),
      'content': instance.content,
      'status_sender': instance.statusSender,
      'status_receiver': instance.statusReceiver,
      'is_group': instance.isGroup,
    };
