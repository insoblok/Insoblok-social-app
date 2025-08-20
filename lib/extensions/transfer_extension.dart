import 'package:insoblok/models/models.dart';

extension TransferExtension on TransferModel {
  Map<String, dynamic> toMap() {
    Map<String, dynamic> result = {
      'user_id': userId,
      'from_currency': fromCurrency,
      'to_currency': toCurrency,
      'from_balance': fromBalance,
      'to_balance': toBalance,
      'update_date': updateDate?.toUtc().toIso8601String(),
      'timestamp': timestamp?.toUtc().toIso8601String(),
    };
    result.removeWhere((k, v) => v == null);
    return result;
  }
}
