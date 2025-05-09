import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

import 'package:insoblok/extensions/extensions.dart';
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
  late UserCredential _userCredential;
  UserCredential get userCredential => _userCredential;

  late final FirebaseFirestore _firestore;
  late final FirebaseStorage _storage;

  Future<void> init() async {
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
      _storage = FirebaseStorage.instance;
      _firestore = FirebaseFirestore.instance;
    } on FirebaseAuthException catch (e) {
      logger.e(e.message);
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

  Future<void> signInEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      _userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      logger.d("Signed in with temporary account.");
    } on FirebaseAuthException catch (e) {
      logger.e(e.message);
    } catch (e) {
      logger.e(e);
    }
  }

  Future<UserModel?> createUser(UserModel user) async {
    try {
      await _firestore.collection('user').add({
        ...user.toJson().toFirebaseJson,
        'timestamp': FieldValue.serverTimestamp(),
        'regdate': FieldValue.serverTimestamp(),
      });
      return getUser(user.uid!);
    } on FirebaseAuthException catch (e) {
      logger.e(e.message);
    } catch (e) {
      logger.e(e);
    }
    return null;
  }

  UserModel? getUserFromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    var json = doc.data();
    if (json != null) {
      json['id'] = doc.id;
      return UserModel.fromJson(json);
    }
    return null;
  }

  Future<UserModel?> getUser(String uid) async {
    try {
      var doc =
          await _firestore
              .collection('user')
              .queryBy(UserQuery.uid, value: uid)
              .get();
      return getUserFromDoc(doc.docs.first);
    } on FirebaseAuthException catch (e) {
      logger.e(e.message);
    } catch (e) {
      logger.e(e.toString());
    }
    return null;
  }

  Future<bool> updateUser(UserModel user) async {
    try {
      await _firestore.collection('user').doc(user.id).update({
        ...user.toJson().toFirebaseJson,
        'timestamp': FieldValue.serverTimestamp(),
      });
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
      await _firestore.collection('user').doc(user.id).delete();
    } on FirebaseAuthException catch (e) {
      logger.e(e.message);
    } catch (e) {
      logger.e(e);
    }
  }

  Future<void> convertAnonymousToPermanent({
    required String email,
    required String password,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null || !user.isAnonymous) {
        throw Exception('No anonymous user to upgrade');
      }

      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );

      _userCredential = await user.linkWithCredential(credential);
    } on FirebaseException catch (e) {
      logger.e(e);
      if (e.code == 'provider-already-linked') {
        final credential = EmailAuthProvider.credential(
          email: email,
          password: password,
        );
        _userCredential = await FirebaseAuth.instance.signInWithCredential(
          credential,
        );
      }
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserStream(String id) {
    return _firestore.collection('user').doc(id).snapshots();
  }

  Future<List<UserModel?>> findUsersByKey(String key) async {
    try {
      List<UserModel?> users = [];
      var uidSnapshot =
          await _firestore
              .collection('user')
              .queryBy(UserQuery.uid, value: key)
              .get();
      users.addAll(uidSnapshot.docs.map((doc) => getUserFromDoc(doc)));

      var firstSnapshot =
          await _firestore
              .collection('user')
              .queryBy(UserQuery.firstName, value: key)
              .get();
      var firstUsers = firstSnapshot.docs.map((doc) => getUserFromDoc(doc));
      for (var user in firstUsers) {
        var idList = users.map((u) => u?.id).toList();
        if (idList.contains(user?.id)) {
          continue;
        }
        users.add(user);
      }

      var lastSnapshot =
          await _firestore
              .collection('user')
              .queryBy(UserQuery.lastName, value: key)
              .get();
      var lastUsers = lastSnapshot.docs.map((doc) => getUserFromDoc(doc));
      for (var user in lastUsers) {
        var idList = users.map((u) => u?.id).toList();
        if (idList.contains(user?.id)) {
          continue;
        }
        users.add(user);
      }

      var nickSnapshot =
          await _firestore
              .collection('user')
              .queryBy(UserQuery.nickID, value: key)
              .get();
      var nickUsers = nickSnapshot.docs.map((doc) => getUserFromDoc(doc));
      for (var user in nickUsers) {
        var idList = users.map((u) => u?.id).toList();
        if (idList.contains(user?.id)) {
          continue;
        }
        users.add(user);
      }

      return users.where((u) => u?.uid != AuthHelper.user?.uid).toList();
    } on FirebaseAuthException catch (e) {
      logger.e(e.message);
    } catch (e) {
      logger.e(e.toString());
    }
    return [];
  }

  Future<String?> uploadImageFromUrl({
    required String imageUrl,
    String? uid,
    String? folderName,
  }) async {
    try {
      var tempDir = await getTemporaryDirectory();
      String fullPath = "${tempDir.path}/${AuthHelper.user?.id}.jpg";
      logger.d('full path $fullPath');

      var dio = Dio();
      var response = await dio.get(
        imageUrl,
        onReceiveProgress: (p, v) {
          logger.d(p);
          logger.d(v);
        },
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) {
            return (status ?? 600) < 500;
          },
        ),
      );
      logger.d(response.headers);
      File file = File(fullPath);
      var raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();

      final String fileName =
          "${AuthHelper.user?.id}_${kFullFormatter.format(DateTime.now())}.jpg";
      final String storagePath =
          folderName != null
              ? 'users/${uid ?? AuthHelper.user?.uid}/$folderName/$fileName'
              : 'users/${uid ?? AuthHelper.user?.uid}/$fileName';

      final Reference storageRef = _storage.ref().child(storagePath);

      // Upload the file
      final UploadTask uploadTask = storageRef.putFile(file);
      final TaskSnapshot snapshot = await uploadTask;

      // Get download URL
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      logger.e('Error uploading image: $e');
      return null;
    }
  }

  Future<String?> uploadFile({
    required File file,
    String? uid,
    String? folderName,
  }) async {
    try {
      final String fileName =
          "${AuthHelper.user?.id}_${kFullFormatter.format(DateTime.now())}.jpg";
      final String storagePath =
          folderName != null
              ? 'users/${uid ?? AuthHelper.user?.uid}/$folderName/$fileName'
              : 'users/${uid ?? AuthHelper.user?.uid}/$fileName';

      final Reference storageRef = _storage.ref().child(storagePath);

      // Upload the file
      final UploadTask uploadTask = storageRef.putFile(file);
      final TaskSnapshot snapshot = await uploadTask;

      // Get download URL
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      logger.e('Error uploading image: $e');
      return null;
    }
  }

  Future<void> deleteImage(String imageUrl) async {
    try {
      final Reference ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      logger.e('Error deleting image: $e');
    }
  }
}

class FirebaseHelper {
  static FirebaseService get service => locator<FirebaseService>();

  static Future<void> init() => service.init();

  static UserCredential get userCredential => service.userCredential;

  static Future<void> signInFirebase() => service.signInFirebase();
  static Future<void> signInEmail({
    required String email,
    required String password,
  }) => service.signInEmail(email: email, password: password);

  static Future<UserModel?> createUser(UserModel user) =>
      service.createUser(user);
  static Future<UserModel?> getUser(String uid) => service.getUser(uid);
  static Future<bool> updateUser(UserModel user) => service.updateUser(user);
  static Future<void> deleteUser(UserModel user) => service.deleteUser(user);
  static Future<void> convertAnonymousToPermanent({
    required String email,
    required String password,
  }) => service.convertAnonymousToPermanent(email: email, password: password);
  static Stream<DocumentSnapshot<Map<String, dynamic>>> getUserStream(
    String id,
  ) => service.getUserStream(id);
  static Future<List<UserModel?>> findUsersByKey(String key) =>
      service.findUsersByKey(key);

  static Future<String?> uploadImageFromUrl({
    required String imageUrl,
    String? uid,
    String? folderName,
  }) => service.uploadImageFromUrl(
    imageUrl: imageUrl,
    uid: uid,
    folderName: folderName,
  );

  static Future<String?> uploadFile({
    required File file,
    String? uid,
    String? folderName,
  }) => service.uploadFile(file: file, uid: uid, folderName: folderName);

  static Future<void> deleteImage(String imageUrl) =>
      service.deleteImage(imageUrl);

  static Map<String, dynamic> fromConvertJson(
    Map<String, dynamic> firebaseJson,
  ) {
    Map<String, dynamic> newJson = {};
    for (var key in firebaseJson.keys) {
      if (key == 'regdate' || key == 'timestamp') {
        var value = firebaseJson[key];
        if (value != null) {
          DateTime utcDateTime = (value as Timestamp).toDate();
          newJson[key] = utcDateTime.toLocal().toIso8601String();
        }
      } else {
        newJson[key] = firebaseJson[key];
      }
    }
    return newJson;
  }
}

enum UserQuery { firstName, lastName, uid, nickID }

extension on Query<Map<String, dynamic>> {
  Query<Map<String, dynamic>> queryBy(UserQuery query, {String? value}) {
    return switch (query) {
      UserQuery.firstName => where('first_name', isEqualTo: value),
      UserQuery.lastName => where('last_name', isEqualTo: value),
      UserQuery.uid => where('uid', isEqualTo: value),
      UserQuery.nickID => where('nick_id', isEqualTo: value),
    };
  }
}
