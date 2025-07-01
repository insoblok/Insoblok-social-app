// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransferModel _$TransferModelFromJson(Map<String, dynamic> json) =>
    _TransferModel(
      id: json['id'] as String?,
      userId: json['user_id'] as String?,
      fromCurrency: json['from_currency'] as String?,
      toCurrency: json['to_currency'] as String?,
      fromBalance: (json['from_balance'] as num?)?.toDouble(),
      toBalance: (json['to_balance'] as num?)?.toDouble(),
      updateDate: json['update_date'] == null
          ? null
          : DateTime.parse(json['update_date'] as String),
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$TransferModelToJson(_TransferModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'from_currency': instance.fromCurrency,
      'to_currency': instance.toCurrency,
      'from_balance': instance.fromBalance,
      'to_balance': instance.toBalance,
      'update_date': instance.updateDate?.toIso8601String(),
      'timestamp': instance.timestamp?.toIso8601String(),
    };
