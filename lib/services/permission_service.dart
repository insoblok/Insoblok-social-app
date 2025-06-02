import 'dart:io';

import 'package:insoblok/utils/utils.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  // Request camera permission
  static Future<bool?> requestCameraPermission() async {
    final status = await Permission.camera.request();

    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      AIHelpers.showToast(msg: 'Camera permission is required to take photos');
      return false;
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
    return null;
  }

  static Future<bool?> requestGalleryPermission() async {
    PermissionStatus status;
    if (Platform.isAndroid) {
      // status = await Permission.storage.request();
      status = await Permission.photos.request();
    } else {
      status = await Permission.photos.request();
    }
    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      AIHelpers.showToast(msg: 'Photo library permission is required');
      return false;
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
    return null;
  }

  static Future<bool?> checkPermission() async {
    Map<Permission, PermissionStatus> statues =
        await [
          Permission.camera,
          Permission.storage,
          Permission.photos,
        ].request();
    PermissionStatus? statusCamera = statues[Permission.camera];
    PermissionStatus? statusStorage = statues[Permission.storage];
    PermissionStatus? statusPhotos = statues[Permission.photos];
    bool isGranted =
        statusCamera == PermissionStatus.granted &&
        statusStorage == PermissionStatus.granted &&
        statusPhotos == PermissionStatus.granted;
    if (isGranted) {
      return true;
    }
    bool isPermanentlyDenied =
        statusCamera == PermissionStatus.permanentlyDenied ||
        statusStorage == PermissionStatus.permanentlyDenied ||
        statusPhotos == PermissionStatus.permanentlyDenied;
    if (isPermanentlyDenied) {
      await openAppSettings();
    }

    return null;
  }
}
