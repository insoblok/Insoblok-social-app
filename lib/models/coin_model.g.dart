// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coin_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CoinModel _$CoinModelFromJson(Map<String, dynamic> json) => _CoinModel(
      icon: json['icon'] as String?,
      type: json['type'] as String?,
      unit: json['unit'] as String?,
      amount: json['amount'] as String?,
    );

Map<String, dynamic> _$CoinModelToJson(_CoinModel instance) =>
    <String, dynamic>{
      'icon': instance.icon,
      'type': instance.type,
      'unit': instance.unit,
      'amount': instance.amount,
    };
