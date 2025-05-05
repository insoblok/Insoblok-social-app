import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:insoblok/models/news_model.dart';
import 'package:insoblok/services/services.dart';

class NewsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get stories
  Future<List<NewsModel>> getNews() async {
    List<NewsModel> result = [];
    if (kDebugMode) {
      final String response = await rootBundle.loadString(
        'assets/data/articles.json',
      );
      final data = await json.decode(response);
      for (var articleJson in (data as List)) {
        var article = NewsModel.fromJson(articleJson);
        if (article.url != null) {
          result.add(article);
        }
      }
    } else {
      var articleSnapshot =
          await _firestore
              .collection('perigon')
              .orderBy('timestamp', descending: false)
              .get();
      for (var doc in articleSnapshot.docs) {
        try {
          var json = doc.data();
          json['id'] = doc.id;
          var article = NewsModel.fromJson(json);
          if (article.url != null) {
            result.add(article);
          }
        } on FirebaseException catch (e) {
          logger.e(e.message);
        }
      }
    }

    logger.d(result.length);

    return result;
  }
}
