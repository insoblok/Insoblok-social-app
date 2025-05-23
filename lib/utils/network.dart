import 'package:dio/dio.dart';

import 'package:insoblok/services/services.dart';

class NetworkUtil {
  static Future<String?> getVTOCredit({
    required String model,
    required String clothingModel,
    required String clothingType,
  }) async {
    try {
      var response = await NetworkHelper.vtoApiRequest(
        'vto',
        method: APIMETHOD.post,
        postParams: {
          'model_photo': model, // Model image URL
          'clothing_photo': clothingModel, // Clothing image URL
          'clothing_type':
              clothingType, // Clothing type. Value can be 'tops', 'bottoms' or 'one-pieces'.
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
