import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class NewsService {
  final CollectionReference _newsCollection = FirebaseFirestore.instance
      .collection('perigon');

  // Get News from Firebase
  Future<List<NewsModel>> getNews() async {
    List<NewsModel> result = [];

    var articleSnapshot =
        await _newsCollection.orderBy('timestamp', descending: false).get();
    for (var doc in articleSnapshot.docs) {
      try {
        var json = (doc.data() as Map<String, dynamic>);
        json['id'] = doc.id;
        var article = NewsModel.fromJson(json);
        if (article.image_url != null) {
          result.add(article);
        }
      } on FirebaseException catch (e) {
        logger.e(e.message);
      }
    }

    logger.d(result.length);

    return result;
  }

  // Get News from Third-Part Api
  Future<List<NewsModel>> getNewsFromService() async {
    List<NewsModel> result = [];

    if (kDebugMode) {
      final String response = await rootBundle.loadString(
        'assets/data/articles.json',
      );
      final data = (await json.decode(response))['results'];
      for (var json in (data as List)) {
        try {
          var news = NewsModel.fromJson(json);
          result.add(news);
        } catch (e) {
          logger.e(e);
          logger.i(json);
        }
      }
    } else {
      var data = await NetworkUtil.getNewsLatest();
      for (var json in (data['results'] as List<Map<String, dynamic>>)) {
        try {
          var news = NewsModel.fromJson(json);
          result.add(news);
        } catch (e) {
          logger.e(e);
          logger.i(json);
        }
      }
    }

    logger.d(result.length);

    return result;
  }

  Future<void> addNews(NewsModel news) async {
    await _newsCollection.add({
      ...news.toJson().toFirebaseJson,
      'timestamp': kFirebaseFormatter.format(DateTime.now().toUtc()),
      'update_date': kFirebaseFormatter.format(DateTime.now().toUtc()),
    });
  }
}
