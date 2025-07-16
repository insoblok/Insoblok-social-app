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
  false,
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
      logger.d(modelUrl);
      var id = await NetworkUtil.getVTOClothingUserImage(
        model: modelUrl,
        clothingModel: photoUrl!,
        clothingType: type,
      );
      if (id != null) {
        // await Future.delayed(const Duration(minutes: 1));
        // var result = await NetworkUtil.getVTOResult(id: id);
        // logger.d(result);
        Map<String, dynamic> result = {};
        while (true) {
          result = await NetworkUtil.getVTOStatus(id: id);
          if (result['status'] == 'completed') break;
        }
        return (result['output'] as List).first;
      } else {
        logger.i('VTO Create ID Error!');
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
