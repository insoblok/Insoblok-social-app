import 'package:permission_handler/permission_handler.dart';

import 'package:insoblok/services/services.dart';

class PermissionService {
  static Future<bool?> requestGalleryPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.mediaLibrary,
      Permission.storage,
    ].request();
    logger.d(statuses);
    for (var key in statuses.keys) {
      var state = statuses[key];
      if (!(state?.isGranted ?? false)) {
        return false;
      }
    }
    return true;
  }

  static Future<bool?> requestCameraPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
    ].request();
    logger.d(statuses);
    for (var key in statuses.keys) {
      var state = statuses[key];
      if (!(state?.isGranted ?? false)) {
        return false;
      }
    }
    return true;
  }
}
