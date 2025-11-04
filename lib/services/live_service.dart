import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

class LiveService {
  final _firestore = FirebaseFirestore.instance;
  CollectionReference<Map<String, dynamic>> get _liveCol => _firestore.collection('live_sessions');

  Stream<List<Map<String, dynamic>>> liveSessionsStream() {
    // Avoid composite index requirement by not ordering with a different field than the filter
    return _liveCol.where('status', isEqualTo: 'live').snapshots().map((s) => s.docs.map((d) => {
          'id': d.id,
          ...d.data(),
        }).toList());
  }

  Future<String> createLiveSession({
    required String userId,
    required String userName,
    required String? userAvatar,
    String? title,
  }) async {
    // Generate a Stream Video callId and create the call on the backend.
    // We keep using Firestore for listing "Live now" items but store callId for viewers to join.
    final callId = const Uuid().v4();
    try {
      // Ensure we use the same initialized app & a fresh ID token
      final user = FirebaseAuth.instance.currentUser;
      // Debug UID to verify auth context
      // ignore: avoid_print
      print('createLivestreamCallV2 using Firebase UID: ${user?.uid}');
      await user?.getIdToken(true);

      // Debug: obtain current App Check token (should be non-null)
      try {
        final appCheckToken = await FirebaseAppCheck.instance.getToken(true);
        // ignore: avoid_print
        print('AppCheck token (trimmed): ${appCheckToken?.substring(0, 12)}...');
      } catch (e) {
        // ignore: avoid_print
        print('Failed to get AppCheck token: $e');
      }

      final callable = FirebaseFunctions.instanceFor(app: Firebase.app(), region: 'us-central1')
          .httpsCallable('createLivestreamCallV2');
      await callable.call({
        'callId': callId,
        if (title != null) 'title': title,
      });
    } catch (e) {
      // If the backend isn't deployed yet, we still create a local record so UI doesn't break.
      // Log the error for debugging.
      // ignore: avoid_print
      print('createLivestreamCallV2 failed: $e');
    }

    final doc = await _liveCol.add({
      'userId': userId,
      'userName': userName,
      'userAvatar': userAvatar,
      'title': title ?? 'Live',
      'status': 'live',
      'startedAt': FieldValue.serverTimestamp(),
      'callId': callId,
    });
    return doc.id;
  }

  Future<void> endLiveSession(String sessionId) async {
    await _liveCol.doc(sessionId).update({'status': 'ended', 'endedAt': FieldValue.serverTimestamp()});
  }

  Future<String?> getCallId(String sessionId) async {
    final doc = await _liveCol.doc(sessionId).get();
    final data = doc.data();
    return data != null ? data['callId'] as String? : null;
  }

  Stream<List<Map<String, dynamic>>> messagesStream(String sessionId) {
    return _liveCol.doc(sessionId).collection('messages').orderBy('timestamp', descending: true).limit(100).snapshots().map((s) => s.docs.map((d) => d.data()).toList());
  }

  Future<void> sendMessage(String sessionId, Map<String, dynamic> msg) async {
    await _liveCol.doc(sessionId).collection('messages').add({
      ...msg,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}


