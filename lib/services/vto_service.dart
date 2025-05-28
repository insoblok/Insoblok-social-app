import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class VTOService {
  static Future<String?> convertVTOClothing({
    required String modelUrl,
    String? clothingLink,
    String clothingType = 'tops',
  }) async {
    try {
      logger.d(modelUrl);
      var id = await NetworkUtil.getVTOCredit(
        model: modelUrl,
        clothingModel: clothingLink!,
        clothingType: clothingType,
      );
      if (id != null) {
        await Future.delayed(const Duration(minutes: 1));
        var result = await NetworkUtil.getVTOResult(id: id);
        logger.d(result);
        return result;
      } else {
        logger.i('VOT Create ID Error!');
      }
    } catch (e) {
      logger.e(e);
    }
    return null;
  }
}
