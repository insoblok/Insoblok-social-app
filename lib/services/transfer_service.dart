import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';

class TransferService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference<Map<String, dynamic>> get transferCollection =>
      _firestore.collection('transfer');

  // Get Transfer
  Future<List<TransferModel>> getTransfers(String userId) async {
    List<TransferModel> result = [];
    var productSnapshot =
        await transferCollection
            .where('uesr_id', isEqualTo: userId)
            .orderBy('timestamp', descending: false)
            .get();
    for (var doc in productSnapshot.docs) {
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
  Future<void> addProduct({required TransferModel transfer}) async {
    await transferCollection.add({
      ...transfer.toMap(),
      'user_id': AuthHelper.user?.id,
    });
  }
}
