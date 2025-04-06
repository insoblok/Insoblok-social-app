import 'dart:io';

import 'package:firebase_core/firebase_core.dart';

import 'package:aiavatar/locator.dart';
import 'package:aiavatar/services/services.dart';

class FirebaseService {
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAN4xG1SxbgazfmqjxG84yX4Il1DV01Jxc',
    appId: '1:811299369538:android:d5d8fed2c82d1f8114f3db',
    messagingSenderId: '811299369538',
    projectId: 'insoblokai',
    storageBucket: 'insoblokai.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyByirpFg5_tyhzrgrWMp__D9pKp2xuM36s',
    appId: '1:811299369538:ios:221147b80644ca5414f3db',
    messagingSenderId: '811299369538',
    projectId: 'insoblokai',
    storageBucket: 'insoblokai.firebasestorage.app',
    iosBundleId: 'insoblok.social.app',
  );

  Future<void> init() async {
    await _initApp();
  }

  Future<void> _initApp() async {
    try {
      await Firebase.initializeApp(
        options: Platform.isAndroid ? android : ios,
      );
    } catch (e) {
      logger.e(e);
    }
  }
}

class FirebseHelper {
  static FirebaseService get service => locator<FirebaseService>();
}
