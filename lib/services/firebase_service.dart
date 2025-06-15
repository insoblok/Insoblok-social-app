import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path_provider/path_provider.dart';

import 'package:insoblok/locator.dart';
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

  late final FirebaseStorage _storage;

  Future<void> init() async {
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
  }

  Future<void> signInFirebase() async {
    var credential = await FirebaseAuth.instance.signInAnonymously();
    _userCredential = credential;
    logger.d("Signed in with temporary account.");
  }

  Future<void> signInEmail({
    required String email,
    required String password,
  }) async {
    final credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );
    _userCredential = await FirebaseAuth.instance.signInWithCredential(
      credential,
    );
    logger.d("Signed in with email & password.");
  }

  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    _userCredential = await FirebaseAuth.instance.signInWithCredential(
      credential,
    );
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
        await signInEmail(email: email, password: password);
      }
    }
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
          logger.d('${(p / v * 100).toStringAsFixed(2)}%');
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

  Future<List<String>> fetchGalleries() async {
    List<String> result = [];
    final ref = _storage.ref('users/${AuthHelper.user?.uid}');

    var folders = await ref.listAll();
    for (var folder in folders.prefixes) {
      var items = await folder.listAll();
      for (var item in items.items) {
        var value = await item.getDownloadURL();
        result.add(value);
      }
    }
    logger.d(result.length);

    return result;
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
  static Future<void> signInWithGoogle() => service.signInWithGoogle();

  static Future<void> convertAnonymousToPermanent({
    required String email,
    required String password,
  }) => service.convertAnonymousToPermanent(email: email, password: password);

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
      if (key == 'update_date' || key == 'timestamp') {
        var value = firebaseJson[key];

        if (value != null) {
          DateTime utcDateTime;
          if (value is String) {
            utcDateTime = DateTime.parse(value);
          } else {
            utcDateTime = (value as Timestamp).toDate();
          }
          newJson[key] = utcDateTime.toLocal().toIso8601String();
        }
      } else {
        newJson[key] = firebaseJson[key];
      }
    }
    return newJson;
  }
}
