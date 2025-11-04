import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insoblok/locator.dart';
import 'package:observable_ish/observable_ish.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/enums/enums.dart';

class MessageService {
  final RxValue<UserModel?> _userRx = RxValue<UserModel?>(null);
  UserModel? get user => _userRx.value;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get messages stream
  Stream<List<MessageModel>> getMessages(String chatRoomId) {
    logger.d("This is getMessages $chatRoomId");
    return _firestore
        .collection('messages')
        .where("chat_id", isEqualTo: chatRoomId)
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
    return _firestore.collection('users2').snapshots();
  }

  // Send a text message
  Future<void> sendMessage({
    required String chatRoomId,
    required String text,
  }) async {
    DocumentReference docRef = await _firestore
      .collection('messages')
      .add({
        'chat_id': chatRoomId,
        'content': text,
        'sender_id': AuthHelper.user?.id,
        'sender_name': AuthHelper.user?.fullName ?? 'Anonymous',
        'timestamp': DateTime.now().toUtc().toIso8601String(),
        'type': MessageType.text.name,
        'is_read': false,
      });
    logger.d("inserted id is ${docRef.id}");
    setLastMessage(chatRoomId, docRef.id);
  }

  // Send an image message
  Future<void> sendImageMessage({
    required String chatRoomId,
    required String imageUrl,
  }) async {
    DocumentReference docRef = await _firestore
        .collection('messages')
        .add({
          'chat_id': chatRoomId,
          'content': '[Image]',
          'sender_id': AuthHelper.user?.id,
          'sender_name': AuthHelper.user?.fullName ?? 'Anonymous',
          'timestamp': DateTime.now().toUtc().toIso8601String(),
          'medias': [imageUrl],
          'type': MessageType.image,
          'is_read': false,
        });
    setLastMessage(chatRoomId, docRef.id);
  }

  // Send a video message
  Future<void> sendVideoMessage({
    required String chatRoomId,
    required String videoUrl,
  }) async {
    DocumentReference docRef = await _firestore
        .collection('messages')
        .add({
          'chat_id': chatRoomId,
          'content': '[Video]',
          'sender_id': AuthHelper.user?.id,
          'sender_name': AuthHelper.user?.fullName ?? 'Anonymous',
          'timestamp': DateTime.now().toUtc().toIso8601String(),
          'medias': [videoUrl],
          'type': MessageType.video,
          'is_read': false,
        });
    setLastMessage(chatRoomId, docRef.id);
  }

  // Send an audio message
  Future<void> sendAudioMessage({
    required String chatRoomId,
    required String audioUrl,
  }) async {
    DocumentReference docRef = await _firestore
        .collection('messages')
        .add({
          'chat_id': chatRoomId,
          'content': '[Audio]',
          'sender_id': AuthHelper.user?.id,
          'sender_name': AuthHelper.user?.fullName ?? 'Anonymous',
          'timestamp': DateTime.now().toUtc().toIso8601String(),
          'medias': [audioUrl],
          'type': MessageType.audio,
          'is_read': false,
        });
    setLastMessage(chatRoomId, docRef.id);
  }

  // Send a gif message
  Future<void> sendGifMessage({
    required String chatRoomId,
    required String gifUrl,
  }) async {
    DocumentReference docRef = await _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .add({
          'chat_id': chatRoomId,
          'content': '[Gif]',
          'sender_id': AuthHelper.user?.id,
          'sender_name': AuthHelper.user?.fullName ?? 'Anonymous',
          'timestamp': DateTime.now().toUtc().toIso8601String(),
          'medias': [gifUrl],
          'type': MessageType.gif,
          'is_read': false,
        });
    setLastMessage(chatRoomId, docRef.id);
  }

  // Send a paid message
  Future<void> sendPaidMessage({
    required String chatRoomId,
    required CoinModel coin,
  }) async {
    DocumentReference docRef = await _firestore
        .collection('messages')
        .add({
          'chat_id': chatRoomId,
          'content': (coin.toJson()),
          'sender_id': AuthHelper.user?.id,
          'sender_name': AuthHelper.user?.fullName ?? 'Anonymous',
          'timestamp': DateTime.now().toUtc().toIso8601String(),
          'type': MessageType.paid,
          'is_read': false,
        });
    setLastMessage(chatRoomId, docRef.id);
  }

  Future<void> setLastMessage(String chatRoomId, String msg) async {
    await _firestore.collection('chatRooms').doc(chatRoomId).update({
      'last_message': msg,
      'update_date': DateTime.now().toUtc().toIso8601String(),
    });
  }

  Future<void> setTyping(String chatRoomId, bool isTyping) async {
    await _firestore.collection('chatRooms').doc(chatRoomId).update({
      '${AuthHelper.user?.id}': isTyping,
    });
  }

  Future<void> clearTypingStatus(bool isTyping) async {
    logger.d(isTyping);
    // var roomSnapshot =
    //     await _firestore
    //         .collection('room')
    //         .where('user_ids', arrayContains: AuthHelper.user?.id)
    //         .get();
    // for (var doc in roomSnapshot.docs) {
    //   logger.d(doc.id);
    //   await _firestore.collection('chatRooms').doc(doc.id).update({
    //     '${AuthHelper.user?.id}': isTyping,
    //   });
    // }
  }

  Future<void> setInitialTypeStatus(
    String chatRoomId,
    String chatUserid,
  ) async {
    await _firestore.collection('chatRooms').doc(chatRoomId).set({
      '${AuthHelper.user?.id}': false,
      chatUserid: false,
    });
  }

  Stream<Map<String, dynamic>> getTypingStatus(String chatRoomId) {
    return _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .snapshots()
        .map((doc) => Map<String, dynamic>.from(doc.data() ?? {}));
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

class MessageHelper {
  static MessageService get service => locator<MessageService>();
  static Future<void> updateTypingStatus(bool isTyping) =>
      service.clearTypingStatus(isTyping);
}
