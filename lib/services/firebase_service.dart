import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:insoblok/locator.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';

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

  late final FirebaseApp _app;
  late final UserCredential _userCredential;
  UserCredential get userCredential => _userCredential;

  late DatabaseReference _userRef;
  late DatabaseReference _messageRef;
  late DatabaseReference _roomRef;

  Future<void> init() async {
    await _initAuth();
    await _initDatabase();
  }

  Future<void> _initAuth() async {
    try {
      _app = await Firebase.initializeApp(
        options: Platform.isAndroid ? android : ios,
      );
      FirebaseAuth.instanceFor(app: _app);
      await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
      _userCredential = await FirebaseAuth.instance.signInAnonymously();
      logger.d("Signed in with temporary account.");
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          logger.e("Anonymous auth hasn't been enabled for this project.");
          break;
        default:
          logger.e("Unknown error.");
      }
    } catch (e) {
      logger.e(e);
    }
  }

  Future<void> _initDatabase() async {
    try {
      _userRef = FirebaseDatabase.instance.ref('user');
      _messageRef = FirebaseDatabase.instance.ref('message');
      _roomRef = FirebaseDatabase.instance.ref('room');
    } catch (e) {
      logger.e(e);
    }
  }

  Future<UserModel?> getUser(String uid) async {
    try {
      final userSnapshot = await _userRef.child(uid).get();
      if (userSnapshot.exists) {
        return UserModel.fromJson(userSnapshot.value as Map<String, dynamic>);
      }
    } on FirebaseAuthException catch (e) {
      logger.e(e.message);
    } catch (e) {
      logger.e(e.toString());
    }
    return null;
  }
}

class FirebaseHelper {
  static FirebaseService get service => locator<FirebaseService>();

  static Future<void> init() => service.init();

  static UserCredential get userCredential => service.userCredential;

  static Future<UserModel?> getUser(String uid) => service.getUser(uid);
}
