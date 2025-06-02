import 'package:dio/dio.dart';

import 'package:insoblok/services/services.dart';

class NetworkUtil {
  static Future<String?> getVTOClothingUserImage({
    required String model, // Model image URL
    required String clothingModel, // Clothing image URL
    required String
    clothingType, // Clothing type. Value can be 'tops', 'bottoms' or 'one-pieces'.
  }) async {
    try {
      var response = await NetworkHelper.vtoApiRequest(
        'vto',
        method: APIMETHOD.post,
        postParams: {
          'model_photo': model,
          'clothing_photo': clothingModel,
          'clothing_type': clothingType,
        },
      );
      logger.d(response.data);
      return response.data;
    } on DioException catch (e) {
      logger.e(e.message);
    } catch (e) {
      logger.e(e.toString());
    }
    return null;
  }

  static Future<String> getVTOJewelryModelImage({
    required String modelUrl, // Model image URL
    required String type,
    String? gender, // Text value 'man' or 'woman' for the model
    String? country, // Name of the country. Example : 'Brazil' or 'France'
    String? age, // Number value between 30 and 70, for the model age
  }) async {
    try {
      var response = await NetworkHelper.vtoApiRequest(
        'ai_model_jewelry',
        method: APIMETHOD.post,
        postParams: {
          'jewelry_image': modelUrl,
          // 'jewelry_image':
          //     "https://cdn.shopify.com/s/files/1/2579/7674/files/Ana-Luisa-Jewelry-Necklaces-Pendant-Necklaces-Gold-Heart-Necklace-Lev-Small-Gold.jpg?v=1704804552",
          'type': type,
          // 'type': 'necklace',
          'gender': gender,
          'country': country,
          'age': age,
        },
      );
      logger.d(response.data);
      return response.data;
    } on DioException catch (e) {
      logger.e(e.message);
      throw (e.message!);
    } catch (e) {
      logger.e(e.toString());
      throw (e.toString());
    }
  }

  static Future<String?> getVTOResult({required String id}) async {
    try {
      var response = await NetworkHelper.vtoApiRequest(
        'results',
        method: APIMETHOD.post,
        postParams: {'id': id},
      );
      return response.data;
    } on DioException catch (e) {
      logger.e(e.message);
    } catch (e) {
      logger.e(e.toString());
    }
    return null;
  }

  static Future<dynamic> getNewsLatest() async {
    try {
      var response = await NetworkHelper.newsApiRequest('latest');
      return response.data;
    } on DioException catch (e) {
      logger.e(e.message);
    } catch (e) {
      logger.e(e.toString());
    }
    return null;
  }
}
