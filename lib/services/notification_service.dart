import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insoblok/services/services.dart';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection('notifications');

  Future<void> sendLiveStartNotification({
    required String fromUserId,
    required String fromUserName,
    required String sessionId,
    required String title,
  }) async {
    try {
      // Get followers of current user
      final userIds =
          await UserService().getFollowingUserIds(userid: fromUserId);
      if (userIds.isEmpty) return;

      final WriteBatch batch = _firestore.batch();
      final now = DateTime.now();
      for (final uid in userIds) {
        final doc = _col.doc();
        batch.set(doc, {
          'toUserId': uid,
          'type': 'live_start',
          'title': title,
          'fromUserId': fromUserId,
          'fromUserName': fromUserName,
          'sessionId': sessionId,
          'createdAt': now.toUtc().toIso8601String(),
          'read': false,
        });
      }
      await batch.commit();
    } catch (e) {
      logger.w('sendLiveStartNotification failed: $e');
    }
  }
}


