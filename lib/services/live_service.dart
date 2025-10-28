import 'package:cloud_firestore/cloud_firestore.dart';

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
    final doc = await _liveCol.add({
      'userId': userId,
      'userName': userName,
      'userAvatar': userAvatar,
      'title': title ?? 'Live',
      'status': 'live',
      'startedAt': FieldValue.serverTimestamp(),
    });
    return doc.id;
  }

  Future<void> endLiveSession(String sessionId) async {
    await _liveCol.doc(sessionId).update({'status': 'ended', 'endedAt': FieldValue.serverTimestamp()});
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


