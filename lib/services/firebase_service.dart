import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
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
import 'package:insoblok/models/models.dart';

import 'package:path/path.dart' as p;

class FirebaseService {
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCsHq6nW30klLFbcfuHxYEOV8UinGE6n-0',
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
    // Check if Firebase is already initialized to avoid duplicate initialization
    try {
      _app = Firebase.app();
    } catch (e) {
      // Firebase not initialized yet, initialize it now
      _app = await Firebase.initializeApp(
        options: Platform.isAndroid ? android : ios,
      );
    }
    FirebaseAuth.instanceFor(app: _app);
    await FirebaseAppCheck.instance.activate(
      androidProvider:
          kDebugMode ? AndroidProvider.debug : AndroidProvider.playIntegrity,
      appleProvider: AppleProvider.appAttest,
      webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    );
    _storage = FirebaseStorage.instance;
  }

  Future<void> signInFirebase() async {
    var credential = await FirebaseAuth.instance.signInAnonymously();
    _userCredential = credential;
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

      if (email.isEmpty) {
        return;
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
    String? storyID,
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

      if (postCategory == "reaction" && storyID != null) {
        final storiesRef = FirebaseFirestore.instance.collection("story");
        await storiesRef.doc(storyID).update({
          "reactions": FieldValue.arrayUnion([downloadUrl]),
        });

        logger.d("post category reaction");
      }

      if (postCategory == "gallery") {
        // Add image URL to user galleries
        final usersRef = FirebaseFirestore.instance.collection("users2");
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
        String fileExtension = p.extension(
          videoUrl,
        ); // get extension (.mp4, .mov, etc.)
        if (fileExtension.isEmpty) {
          fileExtension = ".mp4"; // default
        }

        String fullPath =
            "${tempDir.path}/${AuthHelper.user?.id}$fileExtension";
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

      final String storagePath =
          folderName != null
              ? 'users/${id ?? AuthHelper.user?.id}/$folderName/$fileName'
              : 'users/${id ?? AuthHelper.user?.id}/$fileName';

      final Reference storageRef = _storage.ref().child(storagePath);

      // Upload the video file
      final UploadTask uploadTask = storageRef.putFile(
        file,
        SettableMetadata(
          contentType: "video/mp4",
        ), // <-- ensures correct MIME type
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
        final usersRef = FirebaseFirestore.instance.collection("users2");
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

  Future<List<GalleryModel>> fetchGalleries(String id) async {
    // AuthHelper.user?.id
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    logger.d("currentUserId : $currentUserId");
    // If the passed id matches the current logged-in user's ID,
    // we still use it (but this is where you can add custom logic)
    final targetId = (id == currentUserId) ? currentUserId : id;

    if (targetId == null) {
      throw Exception('No user ID available.');
    }
    List<GalleryModel> galleries = [];
    try {
      final docSnapshot =
          await FirebaseFirestore.instance.collection("users2").doc(id).get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null && data['galleries'] != null) {
          logger.d("gallery json is ${data['galleries']}");
          List<Map<String, dynamic>> lists =
              (data["galleries"] as List).cast<Map<String, dynamic>>();
          for (var l in lists) {
            if (l["status"] == "active") {
              galleries.add(GalleryModel.fromJson(l));
            }
          }
        }
      }

      return galleries; // If no galleries or doc doesn't exist
    } catch (e) {
      logger.e("Error fetching galleries: $e");
      return [];
    }
  }

  Future<List<String>> fetchReactions(String id) async {
    try {
      final docSnapshot =
          await FirebaseFirestore.instance.collection("story").doc(id).get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null && data['reactions'] != null) {
          final reactions = data['reactions'] as List;
          // Handle both old format (List<String>) and new format (List<Map>)
          return reactions
              .map((item) {
                if (item is String) {
                  // Old format: just URL string
                  return item.trim().replaceAll(RegExp(r'\s+'), '');
                } else if (item is Map) {
                  // New format: map with url and prompt - extract URL
                  final url = item['url'] ?? item['link'] ?? '';
                  return url.toString().trim().replaceAll(RegExp(r'\s+'), '');
                }
                return '';
              })
              .where((url) => url.isNotEmpty)
              .toList();
        }
      }

      return []; // If no reactions or doc doesn't exist
    } catch (e) {
      logger.e("Error fetching reactions: $e");
      return [];
    }
  }

  /// Fetch reactions with prompt/type information
  Future<List<Map<String, dynamic>>> fetchReactionsWithPrompt(String id) async {
    try {
      final docSnapshot =
          await FirebaseFirestore.instance.collection("story").doc(id).get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null && data['reactions'] != null) {
          final reactions = data['reactions'] as List;
          // Handle both old format (List<String>) and new format (List<Map>)
          return reactions
              .map((item) {
                if (item is String) {
                  // Old format: just URL string, no prompt
                  return {
                    'url': item.trim().replaceAll(RegExp(r'\s+'), ''),
                    'prompt': null,
                    'type': null,
                  };
                } else if (item is Map) {
                  // New format: map with url and prompt
                  final url = (item['url'] ?? item['link'] ?? '')
                      .toString()
                      .trim()
                      .replaceAll(RegExp(r'\s+'), '');
                  final prompt =
                      item['prompt']?.toString() ?? item['type']?.toString();
                  return {'url': url, 'prompt': prompt, 'type': prompt};
                }
                return <String, dynamic>{};
              })
              .where(
                (reaction) =>
                    reaction['url'] != null &&
                    (reaction['url'] as String).isNotEmpty,
              )
              .toList();
        }
      }

      return []; // If no reactions or doc doesn't exist
    } catch (e) {
      logger.e("Error fetching reactions with prompt: $e");
      return [];
    }
  }

  String? extractMediaUrl(dynamic media) {
    if (media is String) return media;
    if (media is Map && media['link'] is String) return media['link'] as String;
    if (media is Map && media['url'] is String) return media['url'] as String;
    return null;
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

  static Future<void> deleteGalleryImage(String imageUrl) async {
    logger.d("delete imageUrl: $imageUrl");

    final usersRef = FirebaseFirestore.instance.collection("users2");
    await usersRef.doc(AuthHelper.user?.id).update({
      "galleries": FieldValue.arrayRemove([
        imageUrl,
      ]), // removes all exact matches
    });
  }

  static Future<int> deleteMedias(String storyId, int index) async {
    final docRef = FirebaseFirestore.instance.collection('story').doc(storyId);

    // Run Firestore mutation and return both new length + removed URL
    final result = await FirebaseFirestore.instance
        .runTransaction<Map<String, dynamic>>((tx) async {
          final snap = await tx.get(docRef);
          if (!snap.exists) {
            throw StateError('Story $storyId not found');
          }

          final data = (snap.data() as Map<String, dynamic>?) ?? {};
          final List<dynamic> medias = List<dynamic>.from(data['medias'] ?? []);

          if (index < 0 || index >= medias.length) {
            throw RangeError.index(index, medias, 'index', null, medias.length);
          }

          final removed = medias.removeAt(index);
          tx.update(docRef, {'medias': medias});

          return {
            'len': medias.length,
            'url': service.extractMediaUrl(removed), // your existing helper
          };
        });

    // Best-effort Storage delete (outside the transaction)
    final String? url = result['url'] as String?;
    if (url != null && url.startsWith('http')) {
      try {
        await FirebaseStorage.instance.refFromURL(url).delete();
      } catch (e) {
        // log/ignore as needed
        // print('Storage delete failed: $e');
      }
    }

    return result['len'] as int;
  }

  static Future<void> deleteStory(String storyId) async {
    await removeStoryFromUserActions(
      userId: AuthHelper.user!.id!,
      storyId: storyId,
      alsoDeleteStoryDoc: false,
    );
    await FirebaseFirestore.instance
        .collection('story') // use your exact collection name
        .doc(storyId)
        .delete();
  }

  static Future<void> removeStoryFromUserActions({
    required String userId,
    required String storyId,
    bool alsoDeleteStoryDoc = false,
  }) async {
    final db = FirebaseFirestore.instance;
    final userRef = db.collection('users2').doc(userId);
    final storyRef = db.collection('story').doc(storyId);

    await db.runTransaction((tx) async {
      final userSnap = await tx.get(userRef);
      final data = (userSnap.data() as Map<String, dynamic>?) ?? {};
      final List<dynamic> actions = List<dynamic>.from(
        data['user_actions'] ?? const [],
      );

      if (actions.isNotEmpty && actions.every((e) => e is String)) {
        // Fast path: array of strings
        tx.update(userRef, {
          'user_actions': FieldValue.arrayRemove([storyId]),
        });
      } else {
        // General path: array of maps or mixed
        actions.removeWhere((e) {
          if (e is String) return e == storyId;
          if (e is Map) {
            final id = e['id'] ?? e['storyId'] ?? e['ref'] ?? e['docId'];
            final typeOk = (e['type'] == null) || (e['type'] == 'story');
            return id == storyId && typeOk;
          }
          return false;
        });
        tx.update(userRef, {'user_actions': actions});
      }

      if (alsoDeleteStoryDoc) {
        tx.delete(storyRef);
      }
    });
  }

  static Map<String, dynamic> fromConvertJson(
    Map<String, dynamic> firebaseJson,
  ) {
    Map<String, dynamic> newJson = {};
    for (var key in firebaseJson.keys) {
      if (key == 'update_date' ||
          key == 'timestamp' ||
          key == 'created_at' ||
          key == "updated_at" ||
          key == 'birthday' ||
          key == "archived_at" ||
          key == "muted_at" ||
          key == "deleted_at") {
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
      } else if (key == 'reactions') {
        // Handle reactions: convert maps to strings (extract URL) for backward compatibility
        var reactions = firebaseJson[key];
        if (reactions != null && reactions is List) {
          newJson[key] =
              reactions.map((item) {
                if (item is String) {
                  // Old format: already a string
                  return item;
                } else if (item is Map) {
                  // New format: map with url and prompt - extract URL
                  return (item['url'] ?? item['link'] ?? '').toString();
                }
                return item.toString();
              }).toList();
        } else {
          newJson[key] = firebaseJson[key];
        }
      } else {
        newJson[key] = firebaseJson[key];
      }
    }
    return newJson;
  }
}
