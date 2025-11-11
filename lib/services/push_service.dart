import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:insoblok/services/services.dart';

class PushService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> registerDeviceToken() async {
    try {
      // Request permissions on iOS
      if (Platform.isIOS) {
        await _messaging.requestPermission(
          alert: true,
          badge: true,
          sound: true,
        );
      }
      final token = await _messaging.getToken();
      final uid = AuthHelper.user?.id;
      if (token == null || uid == null || uid.isEmpty) return;

      await _firestore.collection('users2').doc(uid).set({
        'fcmTokens': FieldValue.arrayUnion([token]),
      }, SetOptions(merge: true));

      // Keep token up to date
      _messaging.onTokenRefresh.listen((newToken) async {
        final userId = AuthHelper.user?.id;
        if (userId == null) return;
        await _firestore.collection('users2').doc(userId).set({
          'fcmTokens': FieldValue.arrayUnion([newToken]),
        }, SetOptions(merge: true));
      });
    } catch (e) {
      logger.w('registerDeviceToken failed: $e');
    }
  }
}


