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

  Future<UserModel?> createUser(UserModel user) async {
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

  Future<void> deleteUser(UserModel user) async {
    try {
      await _userRef.doc(user.id).delete();
    } on FirebaseAuthException catch (e) {
      logger.e(e.message);
    } catch (e) {
      logger.e(e);
    }
  }

  Stream<QuerySnapshot<UserModel>> getUserStream(String uid) {
    return _userRef.queryBy(UserQuery.uid, value: uid).get().asStream();
  }

  Future<List<UserModel>> findUsersByKey(String key) async {
    try {
      List<UserModel> users = [];
      var uidSnapshot = await _userRef.queryBy(UserQuery.uid, value: key).get();
      users.addAll(uidSnapshot.docs.map((e) => e.data()));

      var firstSnapshot =
          await _userRef.queryBy(UserQuery.firstName, value: key).get();
      users.addAll(firstSnapshot.docs.map((e) => e.data()));

      var lastSnapshot =
          await _userRef.queryBy(UserQuery.firstName, value: key).get();
      users.addAll(lastSnapshot.docs.map((e) => e.data()));
      return users.where((u) => u.uid != AuthHelper.user?.uid).toList();
    } on FirebaseAuthException catch (e) {
      logger.e(e.message);
    } catch (e) {
      logger.e(e.toString());
    }
    return [];
  }

  Future<RoomModel?> createRoom(RoomModel room) async {
    try {
      var value = await _roomRef.add(room.copyWith(
        regDate: kFullDateTimeFormatter.format(
          DateTime.now().toUtc(),
        ),
        updateDate: kFullDateTimeFormatter.format(
          DateTime.now().toUtc(),
        ),
      ));
      var addRoom = room.copyWith(id: value.id);
      await updateRoom(addRoom);
      return addRoom;
    } on FirebaseAuthException catch (e) {
      logger.e(e.message);
    } catch (e) {
      logger.e(e);
    }
    return null;
  }

  Future<List<RoomModel>> getRooms() async {
    try {
      var snapshot = await _roomRef
          .where('related_id', arrayContains: AuthHelper.user?.uid)
          .get();
      return snapshot.docs.map((e) => e.data()).toList();
    } on FirebaseAuthException catch (e) {
      logger.e(e.message);
    } catch (e) {
      logger.e(e.toString());
    }
    return [];
  }

  Future<bool> updateRoom(RoomModel room) async {
    try {
      await _roomRef.doc(room.id).update(room
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

  Stream<QuerySnapshot<RoomModel>> getRoomsStream() {
    return _roomRef.snapshots();
  }
}

class FirebaseHelper {
  static FirebaseService get service => locator<FirebaseService>();

  static Future<void> init() => service.init();

  static UserCredential get userCredential => service.userCredential;

  static Future<void> signInFirebase() => service.signInFirebase();

  static Future<UserModel?> createUser(UserModel user) =>
      service.createUser(user);
  static Future<UserModel?> getUser(String uid) => service.getUser(uid);
  static Future<bool> updateUser(UserModel user) => service.updateUser(user);
  static Future<void> deleteUser(UserModel user) => service.deleteUser(user);
  static Stream<QuerySnapshot<UserModel>> getUserStream(String uid) =>
      service.getUserStream(uid);
  static Future<List<UserModel>> findUsersByKey(String key) =>
      service.findUsersByKey(key);

  static Future<RoomModel?> createRoom(RoomModel room) =>
      service.createRoom(room);
  static Future<List<RoomModel>> getRooms() => service.getRooms();
  static Future<bool> updateRoom(RoomModel room) => service.updateRoom(room);
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
      UserQuery.firstName => where('first_name', isEqualTo: value),
      UserQuery.lastName => where('last_name', isEqualTo: value),
      UserQuery.uid => where('uid', isEqualTo: value),
      UserQuery.recent => orderBy('update_date', descending: true)
    };
  }
}
