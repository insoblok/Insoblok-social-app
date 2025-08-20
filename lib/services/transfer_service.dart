import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';

class TransferTokenName {
  static String USDT = 'USDT';
  static String XP = 'XP';
  static String INSO = 'INSO';
  static String XRP = 'XRP';
}

class TransferService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference<Map<String, dynamic>> get transferCollection =>
      _firestore.collection('transfer');

  // Get Transfer
  Future<List<TransferModel>> getTransfers(String userId) async {
    List<TransferModel> result = [];
    var transferSnapshot =
        await transferCollection
            .where('user_id', isEqualTo: userId)
            .orderBy('timestamp', descending: false)
            .get();
    for (var doc in transferSnapshot.docs) {
      try {
        var json = doc.data();
        json['id'] = doc.id;
        var transfer = TransferModel.fromJson(json);
        if (transfer.userId != null) {
          result.add(transfer);
        }
      } on FirebaseException catch (e) {
        logger.e(e.message);
      }
    }
    return result;
  }

  // Add a transfer
  Future<void> addTransfer({required TransferModel transfer}) async {
    await transferCollection.add({
      ...transfer.toMap(),
      'user_id': AuthHelper.user?.id,
    });
  }

  List<double> getXpToInsoBalance(List<TransferModel> list) {
    double resultFrom = 0;
    double resultTo = 0;
    for (var t in list) {
      if (t.fromCurrency == TransferTokenName.XP &&
          t.toCurrency == TransferTokenName.INSO) {
        resultFrom += t.fromBalance ?? 0;
        resultTo += t.toBalance ?? 0;
      }
    }
    return [resultFrom, resultTo];
  }

  List<double> getInsoToUsdtBalance(List<TransferModel> list) {
    double resultFrom = 0;
    double resultTo = 0;
    for (var t in list) {
      if (t.fromCurrency == TransferTokenName.INSO &&
          t.toCurrency == TransferTokenName.USDT) {
        resultFrom += t.fromBalance ?? 0;
        resultTo += t.toBalance ?? 0;
      }
    }
    return [resultFrom, resultTo];
  }

  TransferModel getTransferModel({
    required String fromToken,
    required String toToken,
    required double from,
    required double to,
  }) {
    return TransferModel(
      userId: AuthHelper.user?.id,
      fromCurrency: fromToken,
      toCurrency: toToken,
      fromBalance: from,
      toBalance: to,
      updateDate: DateTime.now(),
      timestamp: DateTime.now(),
    );
  }
}
