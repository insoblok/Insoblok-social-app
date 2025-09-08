// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) =>
    _TransactionModel(
      id: (json['id'] as num?)?.toInt(),
      from_address: json['from_address'] as String?,
      to_address: json['to_address'] as String?,
      token_symbol: json['token_symbol'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
      tx_hash: json['tx_hash'] as String?,
      timestamp:
          json['timestamp'] == null
              ? null
              : DateTime.parse(json['timestamp'] as String),
      status: json['status'] as String?,
      chain: json['chain'] as String?,
    );

Map<String, dynamic> _$TransactionModelToJson(_TransactionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'from_address': instance.from_address,
      'to_address': instance.to_address,
      'token_symbol': instance.token_symbol,
      'amount': instance.amount,
      'tx_hash': instance.tx_hash,
      'timestamp': instance.timestamp?.toIso8601String(),
      'status': instance.status,
      'chain': instance.chain,
    };
