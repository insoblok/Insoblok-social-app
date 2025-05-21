import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all products
  Future<List<ProductModel>> getProducts() async {
    List<ProductModel> result = [];
    var productSnapshot =
        await _firestore
            .collection('product')
            .orderBy('timestamp', descending: true)
            .get();
    for (var doc in productSnapshot.docs) {
      try {
        var json = doc.data();
        json['id'] = doc.id;
        var product = ProductModel.fromJson(json);
        if (product.uid != null) {
          result.add(product);
        }
      } on FirebaseException catch (e) {
        logger.e(e.message);
      }
    }
    return result;
  }

  // Get products by uid
  Future<List<ProductModel>> getProductsByUid(String uid) async {
    List<ProductModel> result = [];
    var productSnapshot =
        await _firestore
            .collection('product')
            .where('uid', isEqualTo: uid)
            .orderBy('timestamp', descending: false)
            .get();
    for (var doc in productSnapshot.docs) {
      try {
        var json = doc.data();
        json['id'] = doc.id;
        var product = ProductModel.fromJson(json);
        if (product.uid != null) {
          result.add(product);
        }
      } on FirebaseException catch (e) {
        logger.e(e.message);
      }
    }
    return result;
  }

  // Add a product
  Future<void> addProduct({required ProductModel product}) async {
    await _firestore.collection('product').add({
      ...product.toJson().toFirebaseJson,
      'uid': AuthHelper.user?.uid,
      'timestamp': FieldValue.serverTimestamp(),
      'regdate': FieldValue.serverTimestamp(),
    });
  }
}
