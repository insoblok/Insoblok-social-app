import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class ProductCategory {
  static final CLOTHING = 'Clothing';
  static final SHOES = 'Shoes';
  static final JEWELRY = 'Jewelry';

  static final MAN = 'man';
  static final WOMAN = 'woman';
}

const kProductCategoryNames = [
  'Dress',
  'Shirts',
  'Trousers',
  'Shoes',
  'Jewelry',
  'Necklace',
  'Bracelet',
  'Earrings',
  'Sunglasses',
  'Hat/Cap',
];

final kProductCategories = [
  ProductCategory.CLOTHING,
  ProductCategory.CLOTHING,
  ProductCategory.CLOTHING,
  ProductCategory.SHOES,
  ProductCategory.JEWELRY,
  ProductCategory.JEWELRY,
  ProductCategory.JEWELRY,
  ProductCategory.JEWELRY,
  ProductCategory.JEWELRY,
  ProductCategory.CLOTHING,
];

const kProductTypeNames = [
  'one-pieces',
  'tops',
  'bottoms',
  'shoes',
  'ring',
  'necklace',
  'bracelet',
  'earrings',
  'watch',
  'tops',
];

const kProductAvailable = [
  true,
  true,
  true,
  true,
  false,
  false,
  true,
  true,
  true,
  true,
];

class VTOService {


  Future<String?> convertVTOClothing({
    required String modelUrl,
    String? photoUrl,
    String type = 'tops',
  }) async {
    try {

      logger.d("modelUrl : $modelUrl");
      logger.d("photoUrl : $photoUrl");
      logger.d("type : $type");

      if (modelUrl.isEmpty) return null;
      if (photoUrl == null || photoUrl.isEmpty) return null;

      logger.d(modelUrl);

      final id = await NetworkUtil.getVTOClothingUserImage(
        model: modelUrl,
        clothingModel: photoUrl,   // no !
        clothingType: type,
      );

      if (id == null) {
        logger.i('VTO job creation failed: null id');
        return null;
      }

      // Poll status with backoff & timeout
      const pollInterval = Duration(seconds: 1);
      const maxWait = Duration(minutes: 2);
      final deadline = DateTime.now().add(maxWait);

      while (true) {
        // Safety: stop polling after deadline
        if (DateTime.now().isAfter(deadline)) {
          logger.i('VTO polling timed out for id=$id');
          return null;
        }

        final result = await NetworkUtil.getVTOStatus(id: id);
        final status = (result['status'] ?? '').toString().toLowerCase();

        if (status == 'completed') {
          // Prefer explicit get result if your API requires it:
          // final full = await NetworkUtil.getVTOResult(id: id);
          // final outputs = (full?['output'] as List?) ?? const [];
          final outputs = (result['output'] as List?) ?? const [];
          if (outputs.isNotEmpty && outputs.first is String) {
            return outputs.first as String;
          }
          logger.i('VTO completed but output is missing/invalid.');
          return null;
        }

        if (status == 'failed' || status == 'error' || status == 'canceled') {
          logger.i('VTO $status for id=$id: $result');
          return null;
        }

        // still "queued" or "processing"
        await Future.delayed(pollInterval);
      }
    } catch (e, _) {
      logger.e(e);
      return null;
    }
  }


  Future<String?> convertVTOShoes({
    required String model,
    required String shoesModel,
  }) async {
    try {
      var result = await NetworkUtil.getVTOShoesImage(
        model: model,
        shoesModel: shoesModel,
      );
      if (result != null) {
        return result;
      } else {
        logger.i('VTO Error!');
      }
    } catch (e) {
      logger.e(e);
    }
    return null;
  }

  Future<String?> getVTOJewelryModelImage({
    required String modelUrl,
    required String type,
    String? gender,
    String? country,
    String? age,
  }) async {
    try {
      logger.d(modelUrl);
      var id = await NetworkUtil.getVTOJewelryModelImage(
        modelUrl: modelUrl,
        type: type,
        gender: gender,
        country: country,
        age: age,
      );
      await Future.delayed(const Duration(minutes: 1));
      var result = await NetworkUtil.getVTOResult(id: id);
      logger.d(result);
      return result;
    } catch (e) {
      logger.e(e);
    }
    return null;
  }
}
