import 'dart:convert';

import 'package:flutter/services.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference<Map<String, dynamic>> get productCollection =>
      _firestore.collection('product');

  // Get all products
  Future<List<ProductModel>> getProducts() async {
    List<ProductModel> result = [];
    var productSnapshot =
        await productCollection.orderBy('timestamp', descending: true).get();
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
        await productCollection
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
    await productCollection.add({
      ...product.toMap(),
      'uid': AuthHelper.user?.uid,
    });
  }

  // update a product
  Future<void> updateProduct({
    required String id,
    required ProductModel product,
  }) async {
    await productCollection.doc(id).update(product.toMap());
  }

  Future<List<ProductTribeCategoryModel>> getProductTypes() async {
    List<ProductTribeCategoryModel> result = [];
    final String response = await rootBundle.loadString(
      'assets/data/vto_tribe_categories.json',
    );
    final data = (await json.decode(response));
    for (var json in (data as List)) {
      try {
        var category = ProductTribeCategoryModel.fromJson(json);
        result.add(category);
      } catch (e) {
        logger.e(e);
        logger.i(json);
      }
    }
    return result;
  }
}
