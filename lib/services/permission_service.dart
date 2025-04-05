import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<bool?> requestGalleryPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.manageExternalStorage,
      Permission.mediaLibrary,
      Permission.storage,
      Permission.photos,
    ].request();
    for (var key in statuses.keys) {
      var state = statuses[key];
      if (!(state?.isGranted ?? false)) {
        return false;
      }
    }
    return true;
  }
}
