// import 'dart:io';

import 'package:flutter/services.dart';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'package:insoblok/services/services.dart';

class MethodChannelService {
  static Future<String?> onPlatformCameraPicker() async {
    var platformVideoPicker = MethodChannel('insoblok.social.app/video-filter');
    try {
      var result = await platformVideoPicker.invokeMethod<String>('onPicker');
      logger.d(result);
      if (result?.isNotEmpty ?? false) {
        // if (Platform.isAndroid) {
        //   return convertAndroidPathToFlutter(result!);
        // }
        return result;
      }
    } on PlatformException catch (e) {
      logger.e(e.message);
    }
    return null;
  }

  static Future<String> convertAndroidPathToFlutter(String androidPath) async {
    if (androidPath.startsWith('/storage/emulated/0/')) {
      return androidPath.replaceFirst('/storage/emulated/0/', '');
    } else if (androidPath.startsWith('/data/data/')) {
      final appDocDir = await getApplicationDocumentsDirectory();
      return path.join(appDocDir.path, path.basename(androidPath));
    }
    return androidPath;
  }
}
