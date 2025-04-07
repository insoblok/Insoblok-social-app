import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

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

  late DocumentReference _userRef;
  late DocumentReference _messageRef;
  late DocumentReference _roomRef;

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
      await FirebaseAppCheck.instance.activate(
        androidProvider: AndroidProvider.playIntegrity,
        appleProvider: AppleProvider.appAttest,
        webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
      );
    } on FirebaseAuthException catch (e) {
      logger.e(e.message);
    } catch (e) {
      logger.e(e);
    }
  }

  Future<void> _initDatabase() async {
    try {
      var fireStore = FirebaseFirestore.instance.collection('insoblokai');
      _userRef = fireStore.doc('user');
      _messageRef = fireStore.doc('message');
      _roomRef = fireStore.doc('room');
    } catch (e) {
      logger.e(e);
    }
  }

  Future<void> signInFirebase() async {
    try {
      var credential = await FirebaseAuth.instance.signInAnonymously();
      _userCredential = credential;
      logger.d("Signed in with temporary account.");
    } on FirebaseAuthException catch (e) {
      logger.e(e.message);
    } catch (e) {
      logger.e(e);
    }
  }

  Future<UserModel?> getUser(String uid) async {
    try {
      final userSnapshot = await _userRef.collection(uid).get();
      if (userSnapshot.docs.isNotEmpty) {
        return UserModel.fromJson(
          userSnapshot.docs.first as Map<String, dynamic>,
        );
      }
    } on FirebaseAuthException catch (e) {
      logger.e(e.message);
    } catch (e) {
      logger.e(e.toString());
    }
    return null;
  }

  Future<bool> setUser(UserModel user) async {
    try {
      // var ref = _userRef.push();
      // await _userRef.set(<String, dynamic>{
      //   ref.key ?? user.id!: user.toJson(),
      // });
      return true;
    } on FirebaseAuthException catch (e) {
      logger.e(e.message);
    } catch (e) {
      logger.e(e.toString());
    }
    return false;
  }
}

class FirebaseHelper {
  static FirebaseService get service => locator<FirebaseService>();

  static Future<void> init() => service.init();

  static UserCredential get userCredential => service.userCredential;

  static Future<void> signInFirebase() => service.signInFirebase();

  static Future<UserModel?> getUser(String uid) => service.getUser(uid);
  static Future<bool> setUser(UserModel user) => service.setUser(user);
}
