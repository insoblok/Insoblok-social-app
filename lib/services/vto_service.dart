import 'dart:io';

import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class VTOService {
  static Future<String?> convertVTOClothing({
    required String path,
    String? clothingLink,
    String clothingType = 'tops',
    String folderName = 'clothing',
  }) async {
    try {
      var modelUrl = await FirebaseHelper.uploadFile(
        file: File(path),
        folderName: folderName,
      );
      if (modelUrl != null) {
        logger.d(modelUrl);
        var id = await NetworkUtil.getVTOCredit(
          model: modelUrl,
          clothingModel: clothingLink!,
          clothingType: clothingType,
        );
        if (id != null) {
          logger.d(id);
          await Future.delayed(const Duration(minutes: 1));
          var result = await NetworkUtil.getVTOResult(id: id);
          logger.d(result);
          return result;
        } else {
          logger.i('VOT Create ID Error!');
        }
      } else {
        logger.i('Fireabase Upload Error!');
      }
    } catch (e) {
      logger.e(e);
    }
    return null;
  }
}
