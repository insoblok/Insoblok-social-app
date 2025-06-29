import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:insoblok/services/services.dart';

part 'transfer_model.freezed.dart';
part 'transfer_model.g.dart';

@freezed
abstract class TransferModel with _$TransferModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory TransferModel({
    String? id,
    String? userId,
    String? fromCurrency,
    String? toCurrency,
    int? fromBalance,
    int? toBalance,
    DateTime? updateDate,
    DateTime? timestamp,
  }) = _TransferModel;

  factory TransferModel.fromJson(Map<String, dynamic> json) =>
      _$TransferModelFromJson(FirebaseHelper.fromConvertJson(json));
}
