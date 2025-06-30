import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';

class TransferTokenName {
  static String USDT = 'USDT';
  static String XP = 'XP';
  static String INSO = 'INSO';
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
            .where('uesr_id', isEqualTo: userId)
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

  List<int> getXpToInsoBalance(List<TransferModel> list) {
    int resultFrom = 0;
    int resultTo = 0;
    for (var t in list) {
      if (t.fromCurrency == TransferTokenName.XP &&
          t.toCurrency == TransferTokenName.INSO) {
        resultFrom += t.fromBalance ?? 0;
        resultTo += t.toBalance ?? 0;
      }
    }
    return [resultFrom, resultTo];
  }

  List<int> getInsoToUsdtBalance(List<TransferModel> list) {
    int resultFrom = 0;
    int resultTo = 0;
    for (var t in list) {
      if (t.fromCurrency == TransferTokenName.INSO &&
          t.toCurrency == TransferTokenName.USDT) {
        resultFrom += t.fromBalance ?? 0;
        resultTo += t.toBalance ?? 0;
      }
    }
    return [resultFrom, resultTo];
  }
}
