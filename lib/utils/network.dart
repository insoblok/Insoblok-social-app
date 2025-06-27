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
        // 'vto',
        'run',
        method: APIMETHOD.post,
        postParams: {
          // 'model_photo': model,
          'model_image': model,
          // 'clothing_photo': clothingModel,
          'garment_image': clothingModel,
          // 'clothing_type': clothingType,
          'category': clothingType,
        },
      );
      logger.d(response.data);
      return response.data['id'];
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

  static Future<dynamic> getVTOStatus({required String id}) async {
    try {
      var response = await NetworkHelper.vtoApiRequest('status/$id');
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

  static Future<String?> getVTOEditImage({
    required String model,
    required String prompt,
  }) async {
    try {
      var response = await NetworkHelper.theneApiRequest(
        'edit',
        method: APIMETHOD.post,
        postParams: {
          'image': model,
          'prompt': prompt,
          'negative': 'poor details',
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

  static Future<Map<String, dynamic>?> createKieAvatar(
    Map<String, dynamic> request,
  ) async {
    try {
      var response = await NetworkHelper.avatarApiRequest(
        'generate',
        method: APIMETHOD.post,
        postParams: request,
      );
      return response.data;
    } on DioException catch (e) {
      logger.e(e.message);
    } catch (e) {
      logger.e(e.toString());
    }
    return null;
  }

  static Map<String, dynamic> kieGenerateMap({
    required String fileUrl,
    String? prompt,
    required String size,
  }) => {
    // (Optional) List of file URLs, such as image URLs. Maximum 5 images supported. Supported file formats: .jfif, .pjpeg, .jpeg, .pjp, .jpg, .png, .webp
    "filesUrl": [fileUrl],
    // (Optional) Prompt describing what you want the 4o image to generate. Either fileUrl/filesUrl or prompt must be provided Example: A beautiful sunset over the mountains
    "prompt": prompt,
    // (Required) Image size ratio, must be one of the supported formats Possible values: [1:1, 3:2, 2:3]
    "size": size,
    "nVariants": 1,
  };

  static Future<Map<String, dynamic>?> getKieProgress(String taskId) async {
    try {
      var response = await NetworkHelper.avatarApiRequest(
        'record-info',
        queryParams: {'taskId': taskId},
      );
      return response.data;
    } on DioException catch (e) {
      logger.e(e.message);
    } catch (e) {
      logger.e(e.toString());
    }
    return null;
  }

  static Future<Map<String, dynamic>?> downloadKieAvatar({
    required String taskId,
    required String url,
  }) async {
    try {
      var response = await NetworkHelper.avatarApiRequest(
        'download-url',
        method: APIMETHOD.post,
        postParams: {'taskId': taskId, 'url': url},
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
