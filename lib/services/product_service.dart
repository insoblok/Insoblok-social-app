import 'dart:convert';

import 'package:flutter/services.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference<Map<String, dynamic>> get productCollection =>
      _firestore.collection('product');

  // Validate if a URL is a valid HTTP/HTTPS URL
  bool _isValidUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  // Check if an image exists at the URL (HEAD request)
  Future<bool> _imageExists(String url) async {
    try {
      final uri = Uri.parse(url);
      final response = await http
          .head(uri)
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () {
              return http.Response('Timeout', 408);
            },
          );
      // Check if status code indicates success (200-299) or redirect (300-399)
      return response.statusCode >= 200 && response.statusCode < 400;
    } catch (e) {
      logger.e('Error checking image existence for $url: $e');
      return false;
    }
  }

  // Get all products
  Future<List<ProductModel>> getProducts() async {
    List<ProductModel> candidates = [];
    var productSnapshot =
        await productCollection.orderBy('timestamp', descending: true).get();

    // First pass: collect all products with valid URL format
    for (var doc in productSnapshot.docs) {
      try {
        var json = doc.data();
        json['id'] = doc.id;
        var product = ProductModel.fromJson(json);

        // Basic validation: check if required fields exist and URLs are valid format
        if (product.userId != null &&
            product.modelImage != null &&
            product.modelImage!.isNotEmpty &&
            product.avatarImage != null &&
            product.avatarImage!.isNotEmpty &&
            _isValidUrl(product.modelImage) &&
            _isValidUrl(product.avatarImage)) {
          candidates.add(product);
        }
      } on FirebaseException catch (e) {
        logger.e(e.message);
      } catch (e) {
        // Catch any other parsing errors
        logger.e('Error parsing product: $e');
      }
    }

    // Second pass: validate that images actually exist at the URLs
    List<ProductModel> result = [];
    final List<Future<void>> validationTasks = [];

    for (var product in candidates) {
      validationTasks.add(
        Future(() async {
          try {
            final modelImageExists = await _imageExists(product.modelImage!);
            final avatarImageExists = await _imageExists(product.avatarImage!);

            if (modelImageExists && avatarImageExists) {
              result.add(product);
            } else {
              logger.d(
                'Product ${product.id} excluded: modelImage exists=$modelImageExists, avatarImage exists=$avatarImageExists',
              );
            }
          } catch (e) {
            logger.e('Error validating images for product ${product.id}: $e');
          }
        }),
      );
    }

    // Wait for all image validations to complete
    await Future.wait(validationTasks);

    return result;
  }

  // Get products by id
  Future<List<ProductModel>> getProductsById(String id) async {
    List<ProductModel> result = [];
    var productSnapshot =
        await productCollection
            .where('uesr_id', isEqualTo: id)
            .orderBy('timestamp', descending: false)
            .get();
    for (var doc in productSnapshot.docs) {
      try {
        var json = doc.data();
        json['id'] = doc.id;
        var product = ProductModel.fromJson(json);
        if (product.userId != null) {
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
      'user_id': AuthHelper.user?.id,
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
