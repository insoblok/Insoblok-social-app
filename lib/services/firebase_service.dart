import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:insoblok/locator.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

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

  late CollectionReference<UserModel> _userRef;
  late CollectionReference<MessageModel> _messageRef;
  late CollectionReference<RoomModel> _roomRef;

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
      _userRef = FirebaseFirestore.instance
          .collection('user')
          .withConverter<UserModel>(
            fromFirestore: (snapshot, _) =>
                UserModel.fromJson(snapshot.data()!),
            toFirestore: (user, _) => user.toJson(),
          );
      _messageRef = FirebaseFirestore.instance
          .collection('message')
          .withConverter<MessageModel>(
            fromFirestore: (snapshot, _) =>
                MessageModel.fromJson(snapshot.data()!),
            toFirestore: (message, _) => message.toJson(),
          );
      _roomRef = FirebaseFirestore.instance
          .collection('room')
          .withConverter<RoomModel>(
            fromFirestore: (snpashot, _) =>
                RoomModel.fromJson(snpashot.data()!),
            toFirestore: (room, _) => room.toJson(),
          );
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

  Future<UserModel?> addUser(UserModel user) async {
    try {
      var value = await _userRef.add(user);
      var addUser = user.copyWith(id: value.id);
      await updateUser(addUser);
      return addUser;
    } on FirebaseAuthException catch (e) {
      logger.e(e.message);
    } catch (e) {
      logger.e(e);
    }
    return null;
  }

  Future<UserModel?> getUser(String uid) async {
    try {
      var userSnpashot =
          await _userRef.queryBy(UserQuery.uid, value: uid).get();
      return userSnpashot.docs.first.data();
    } on FirebaseAuthException catch (e) {
      logger.e(e.message);
    } catch (e) {
      logger.e(e.toString());
    }
    return null;
  }

  Future<bool> updateUser(UserModel user) async {
    try {
      await _userRef.doc(user.id).update(user
          .copyWith(
            updateDate: kFullDateTimeFormatter.format(
              DateTime.now().toUtc(),
            ),
          )
          .toJson());
      return true;
    } on FirebaseAuthException catch (e) {
      logger.e(e.message);
    } catch (e) {
      logger.e(e);
    }
    return false;
  }

  Future<void> removeUser(UserModel user) async {
    try {
      await _userRef.doc(user.id).delete();
    } on FirebaseAuthException catch (e) {
      logger.e(e.message);
    } catch (e) {
      logger.e(e);
    }
  }

  Stream<QuerySnapshot<RoomModel>> getRoomsStream() {
    return _roomRef.snapshots();
  }
}

class FirebaseHelper {
  static FirebaseService get service => locator<FirebaseService>();

  static Future<void> init() => service.init();

  static UserCredential get userCredential => service.userCredential;

  static Future<void> signInFirebase() => service.signInFirebase();

  static Future<UserModel?> addUser(UserModel user) => service.addUser(user);
  static Future<UserModel?> getUser(String uid) => service.getUser(uid);
  static Future<bool> updateUser(UserModel user) => service.updateUser(user);
  static Future<void> removeUser(UserModel user) => service.removeUser(user);

  static Stream<QuerySnapshot<RoomModel>> getRoomsStream() =>
      service.getRoomsStream();
}

enum UserQuery {
  firstName,
  lastName,
  uid,
  recent,
}

extension on Query<UserModel> {
  Query<UserModel> queryBy(
    UserQuery query, {
    String? value,
  }) {
    return switch (query) {
      UserQuery.firstName => where('first_name', arrayContainsAny: [value]),
      UserQuery.lastName => where('last_name', arrayContainsAny: [value]),
      UserQuery.uid => where('uid', isEqualTo: value),
      UserQuery.recent => orderBy('update_date', descending: true)
    };
  }
}

enum RoomQuery {
  year,
  likesAsc,
  likesDesc,
  rated,
  sciFi,
  fantasy,
}

extension on Query<RoomModel> {
  Query<RoomModel> queryBy(RoomQuery query) {
    return switch (query) {
      RoomQuery.fantasy => where('genre', arrayContainsAny: ['fantasy']),
      RoomQuery.sciFi => where('genre', arrayContainsAny: ['sci-fi']),
      RoomQuery.likesAsc ||
      RoomQuery.likesDesc =>
        orderBy('likes', descending: query == RoomQuery.likesDesc),
      RoomQuery.year => orderBy('year', descending: true),
      RoomQuery.rated => orderBy('rated', descending: true)
    };
  }
}
