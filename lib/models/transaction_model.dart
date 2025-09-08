import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:insoblok/services/services.dart';

part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

@freezed
abstract class TransactionModel with _$TransactionModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory TransactionModel({
    int? id,
    String? from_address,
    String? to_address,
    String? token_symbol,
    double? amount,
    String? tx_hash,
    DateTime? timestamp,
    String? status,
    String? chain
  }) = _TransactionModel;

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(FirebaseHelper.fromConvertJson(json));
}  