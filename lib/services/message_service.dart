import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:observable_ish/observable_ish.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';

class MessageService {
  final RxValue<UserModel?> _userRx = RxValue<UserModel?>(null);
  UserModel? get user => _userRx.value;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get messages stream
  Stream<List<MessageModel>> getMessages(String chatRoomId) {
    return _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) {
                var data = doc.data();
                data['id'] = doc.id;
                return MessageModel.fromJson(data);
              }).toList(),
        );
  }

  // Get user status
  Stream<QuerySnapshot<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection('user').snapshots();
  }

  // Send a text message
  Future<void> sendMessage({
    required String chatRoomId,
    required String text,
  }) async {
    await _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .add({
          'content': text,
          'sender_id': AuthHelper.user?.id,
          'sender_name': AuthHelper.user?.fullName ?? 'Anonymous',
          'timestamp': DateTime.now().toUtc().toIso8601String(),
          'type': 'text',
          'is_read': false,
        });
    setLastMessage(chatRoomId, text);
  }

  // Send an image message
  Future<void> sendImageMessage({
    required String chatRoomId,
    required String imageUrl,
  }) async {
    await _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .add({
          'content': '[Image]',
          'sender_id': AuthHelper.user?.id,
          'sender_name': AuthHelper.user?.fullName ?? 'Anonymous',
          'timestamp': DateTime.now().toUtc().toIso8601String(),
          'url': imageUrl,
          'type': 'image',
          'is_read': false,
        });
    setLastMessage(chatRoomId, 'Image');
  }

  // Send a video message
  Future<void> sendVideoMessage({
    required String chatRoomId,
    required String videoUrl,
  }) async {
    await _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .add({
          'content': '[Video]',
          'sender_id': AuthHelper.user?.id,
          'sender_name': AuthHelper.user?.fullName ?? 'Anonymous',
          'timestamp': DateTime.now().toUtc().toIso8601String(),
          'url': videoUrl,
          'type': 'video',
          'is_read': false,
        });
    setLastMessage(chatRoomId, 'Video');
  }

  // Send an audio message
  Future<void> sendAudioMessage({
    required String chatRoomId,
    required String audioUrl,
  }) async {
    await _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .add({
          'content': '[Audio]',
          'sender_id': AuthHelper.user?.id,
          'sender_name': AuthHelper.user?.fullName ?? 'Anonymous',
          'timestamp': DateTime.now().toUtc().toIso8601String(),
          'url': audioUrl,
          'type': 'audio',
          'is_read': false,
        });
    setLastMessage(chatRoomId, 'Audio');
  }

  // Send a gif message
  Future<void> sendGifMessage({
    required String chatRoomId,
    required String gifUrl,
  }) async {
    await _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .add({
          'content': '[Gif]',
          'sender_id': AuthHelper.user?.id,
          'sender_name': AuthHelper.user?.fullName ?? 'Anonymous',
          'timestamp': DateTime.now().toUtc().toIso8601String(),
          'url': gifUrl,
          'type': 'gif',
          'is_read': false,
        });
    setLastMessage(chatRoomId, 'Gif');
  }

  // Send a paid message
  Future<void> sendPaidMessage({
    required String chatRoomId,
    required CoinModel coin,
  }) async {
    await _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .add({
          'content': (coin.toJson()),
          'sender_id': AuthHelper.user?.id,
          'sender_name': AuthHelper.user?.fullName ?? 'Anonymous',
          'timestamp': DateTime.now().toUtc().toIso8601String(),
          'type': 'paid',
          'is_read': false,
        });
    setLastMessage(chatRoomId, 'Paid');
  }

  Future<void> setLastMessage(String chatRoomId, String msg) async {
    await _firestore.collection('room').doc(chatRoomId).update({
      'content': msg,
      'update_date': DateTime.now().toUtc().toIso8601String(),
    });
  }

  Future<void> setTyping(String chatRoomId, bool isTyping) async {
    await _firestore.collection('chatRooms').doc(chatRoomId).update({
      'typing.${AuthHelper.user?.id}': isTyping,
    });
  }

  Stream<Map<String, bool>> getTypingStatus(String chatRoomId) {
    return _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .snapshots()
        .map((doc) => Map<String, bool>.from(doc.data()?['typing'] ?? {}));
  }

  Future<int> getUnreadMessageCount(String chatRoomId) async {
    final messages =
        await _firestore
            .collection('chatRooms')
            .doc(chatRoomId)
            .collection('messages')
            .where('sender_id', isNotEqualTo: AuthHelper.user?.id)
            .where('is_read', isEqualTo: false)
            .get();
    return messages.docs.length;
  }

  Future<void> markMessagesAsRead(String chatRoomId) async {
    final messages =
        await _firestore
            .collection('chatRooms')
            .doc(chatRoomId)
            .collection('messages')
            .where('sender_id', isNotEqualTo: AuthHelper.user?.id)
            .where('is_read', isEqualTo: false)
            .get();

    final batch = _firestore.batch();
    for (final doc in messages.docs) {
      batch.update(doc.reference, {'is_read': true});
    }
    await batch.commit();
  }
}
