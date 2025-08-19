import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

import 'package:insoblok/locator.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

import 'package:path/path.dart' as p;
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
    // final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    // final GoogleSignInAuthentication? googleAuth =
    //     await googleUser?.authentication;

    // // Create a new credential
    // final credential = GoogleAuthProvider.credential(
    //   accessToken: googleAuth?.accessToken,
    //   idToken: googleAuth?.idToken,
    // );
    // _userCredential = await FirebaseAuth.instance.signInWithCredential(
    //   credential,
    // );
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
    String? id,
    String? folderName,
    String? postCategory,
    String? storyID
  }) async {
    try {
      File file;

      if (imageUrl.startsWith('http')) {
        // It's a remote image, download it first
        var tempDir = await getTemporaryDirectory();
        String fullPath = "${tempDir.path}/${AuthHelper.user?.id}.AVIF";
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
            validateStatus: (status) => (status ?? 600) < 500,
          ),
        );

        file = File(fullPath);
        var raf = file.openSync(mode: FileMode.write);
        raf.writeFromSync(response.data);
        await raf.close();
      } else {
        // It's a local file path
        file = File(imageUrl);
      }

      final String fileName =
          "${AuthHelper.user?.id}_${kFullFormatter.format(DateTime.now())}.AVIF";

      final String storagePath = folderName != null
          ? 'users/${id ?? AuthHelper.user?.id}/$folderName/$fileName'
          : 'users/${id ?? AuthHelper.user?.id}/$fileName';

      final Reference storageRef = _storage.ref().child(storagePath);

      // Upload the file
      final UploadTask uploadTask = storageRef.putFile(file);
      final TaskSnapshot snapshot = await uploadTask;

      // Get download URL
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      
      if (postCategory == "reaction" && storyID != null) {
          final storiesRef = FirebaseFirestore.instance.collection("story");
          await storiesRef.doc(storyID).update({
            "reactions": FieldValue.arrayUnion([downloadUrl]),
          });

          logger.d("post category reaction");
      }

      if (postCategory == "gallery") {
        // Add image URL to user galleries
        final usersRef = FirebaseFirestore.instance.collection("user");
        await usersRef.doc(id ?? AuthHelper.user?.id).update({
          "galleries": FieldValue.arrayUnion([downloadUrl]),
        });

        logger.d("post category gallery");
      }
      
      return downloadUrl;
    } catch (e) {
      logger.e('Error uploading image: $e');
      return null;
    }
  }


  Future<String?> uploadVideoFile({
    required String videoUrl, // <-- renamed for clarity
    String? id,
    String? folderName,
    String? postCategory,
    String? storyID,
  }) async {
    try {
      File file;

      if (videoUrl.startsWith('http')) {
        // It's a remote video, download it first
        var tempDir = await getTemporaryDirectory();
        String fileExtension = p.extension(videoUrl); // get extension (.mp4, .mov, etc.)
        if (fileExtension.isEmpty) {
          fileExtension = ".mp4"; // default
        }

        String fullPath = "${tempDir.path}/${AuthHelper.user?.id}$fileExtension";
        logger.d('full path $fullPath');

        var dio = Dio();
        var response = await dio.get(
          videoUrl,
          onReceiveProgress: (p, v) {
            logger.d('${(p / v * 100).toStringAsFixed(2)}%');
          },
          options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) => (status ?? 600) < 500,
          ),
        );

        file = File(fullPath);
        var raf = file.openSync(mode: FileMode.write);
        raf.writeFromSync(response.data);
        await raf.close();
      } else {
        // It's a local file path
        file = File(videoUrl);
      }

      // Get file extension from original file path
      String ext = p.extension(file.path);
      if (ext.isEmpty) {
        ext = ".mp4"; // default extension
      }

      final String fileName =
          "${AuthHelper.user?.id}_${kFullFormatter.format(DateTime.now())}$ext";

      final String storagePath = folderName != null
          ? 'users/${id ?? AuthHelper.user?.id}/$folderName/$fileName'
          : 'users/${id ?? AuthHelper.user?.id}/$fileName';

      final Reference storageRef = _storage.ref().child(storagePath);

      // Upload the video file
      final UploadTask uploadTask = storageRef.putFile(
        file,
        SettableMetadata(contentType: "video/mp4"), // <-- ensures correct MIME type
      );
      final TaskSnapshot snapshot = await uploadTask;

      // Get download URL
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      if (postCategory == "reaction" && storyID != null) {
        final storiesRef = FirebaseFirestore.instance.collection("story");
        await storiesRef.doc(storyID).update({
          "reactions": FieldValue.arrayUnion([downloadUrl]),
        });

        logger.d("post category reaction");
      }

      if (postCategory == "gallery") {
        // Add video URL to user galleries
        final usersRef = FirebaseFirestore.instance.collection("user");
        await usersRef.doc(id ?? AuthHelper.user?.id).update({
          "galleries": FieldValue.arrayUnion([downloadUrl]),
        });

        logger.d("post category gallery");
      }

      return downloadUrl;
    } catch (e) {
      logger.e('Error uploading video: $e');
      return null;
    }
  }


  Future<void> createFolderInFirebaseStorage(String folderPath) async {
    try {
      final ref = FirebaseStorage.instance.ref('$folderPath/.keep');

      // Upload a small dummy string
      await ref.putString('placeholder');
      print('Folder "$folderPath" created (by uploading .keep file)');
    } catch (e) {
      print('Error creating folder: $e');
    }
}

  Future<String?> uploadFile({
    required File file,
    String? id,
    String? folderName,
  }) async {
    try {
      final String fileName =
          "${AuthHelper.user?.id}_${kFullFormatter.format(DateTime.now())}.AVIF";
      final String storagePath =
          folderName != null
              ? 'users/${id ?? AuthHelper.user?.id}/$folderName/$fileName'
              : 'users/${id ?? AuthHelper.user?.id}/$fileName';

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

  Future<String?> uploadFileData({
    required Uint8List fileData,
    String? id,
    String? folderName,
  }) async {
    try {
      final String fileName =
          "${AuthHelper.user?.id}_${kFullFormatter.format(DateTime.now())}.AVIF";
      final String storagePath =
          folderName != null
              ? 'users/${id ?? AuthHelper.user?.id}/$folderName/$fileName'
              : 'users/${id ?? AuthHelper.user?.id}/$fileName';

      final Reference storageRef = _storage.ref().child(storagePath);

      // Upload the file
      final UploadTask uploadTask = storageRef.putData(fileData);
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

  Future<List<String>> fetchGalleries(String id) async {
    
    // AuthHelper.user?.id
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    logger.d("currentUserId : $currentUserId");
    // If the passed id matches the current logged-in user's ID,
    // we still use it (but this is where you can add custom logic)
    final targetId = (id == currentUserId) ? currentUserId : id;

    if (targetId == null) {
      throw Exception('No user ID available.');
    }

    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection("user")
          .doc(id)
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null && data['galleries'] != null) {
          // Ensure it's a List<String>
          return List<String>.from(data['galleries']);
        }
      }

      return []; // If no galleries or doc doesn't exist
    } catch (e) {
      logger.e("Error fetching galleries: $e");
      return [];
    }
  }

  Future<List<String>> fetchReactions(String id) async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection("story")
          .doc(id)
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null && data['reactions'] != null) {
          // Ensure it's a List<String>
          return List<String>.from(data['reactions']);
        }
      }

      return []; // If no reactions or doc doesn't exist
    } catch (e) {
      logger.e("Error fetching reactions: $e");
      return [];
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
  static Future<void> signInWithGoogle() => service.signInWithGoogle();

  static Future<void> convertAnonymousToPermanent({
    required String email,
    required String password,
  }) => service.convertAnonymousToPermanent(email: email, password: password);

  static Future<String?> uploadImageFromUrl({
    required String imageUrl,
    String? id,
    String? folderName,
    String? postCategory,
    String? storyID,
  }) => service.uploadImageFromUrl(
    imageUrl: imageUrl,
    id: id,
    folderName: folderName,
    postCategory: postCategory,
    storyID: storyID,
  );

  static Future<String?> uploadVideoFile({
    required String videoUrl,
    String? id,
    String? folderName,
    String? postCategory,
    String? storyID,
  }) => service.uploadVideoFile(
    videoUrl: videoUrl,
    id: id,
    folderName: folderName,
    postCategory: postCategory,
    storyID: storyID,
  );

  static Future<String?> uploadFile({
    required File file,
    String? id,
    String? folderName,
  }) => service.uploadFile(file: file, id: id, folderName: folderName);

  static Future<String?> uploadFileData({
    required Uint8List fileData,
    String? id,
    String? folderName,
  }) => service.uploadFileData(
    fileData: fileData,
    id: id,
    folderName: folderName,
  );

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
      } else if (key == 'content') {
        newJson[key] =
            (firebaseJson[key] is String)
                ? firebaseJson[key]
                : jsonEncode(firebaseJson[key]);
      } else {
        newJson[key] = firebaseJson[key];
      }
    }
    return newJson;
  }
}
