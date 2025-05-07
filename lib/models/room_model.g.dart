// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RoomModel _$RoomModelFromJson(Map<String, dynamic> json) => _RoomModel(
      id: json['id'] as String?,
      uid: json['uid'] as String?,
      uids: (json['uids'] as List<dynamic>?)?.map((e) => e as String?).toList(),
      regdate: json['regdate'] == null
          ? null
          : DateTime.parse(json['regdate'] as String),
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
      content: json['content'] as String?,
      statusSender: json['status_sender'] as String?,
      statusReceiver: json['status_receiver'] as String?,
    );

Map<String, dynamic> _$RoomModelToJson(_RoomModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'uids': instance.uids,
      'regdate': instance.regdate?.toIso8601String(),
      'timestamp': instance.timestamp?.toIso8601String(),
      'content': instance.content,
      'status_sender': instance.statusSender,
      'status_receiver': instance.statusReceiver,
    };
