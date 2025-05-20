import 'package:dio/dio.dart';

import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class NetworkUtil {
  static Future<String?> getVTOCredit({
    required String model,
    String? clothingModel = kDefaultClothesModelLink,
    required String clothingType,
  }) async {
    try {
      var response = await NetworkHelper.apiRequest(
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
      var response = await NetworkHelper.apiRequest(
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
}
