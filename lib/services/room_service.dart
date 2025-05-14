import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';

class RoomService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get rooms
  Future<List<RoomModel>> getRooms() async {
    List<RoomModel> result = [];
    var roomSnapshot =
        await _firestore
            .collection('room')
            .orderBy('timestamp', descending: false)
            .where('uids', arrayContains: AuthHelper.user?.uid)
            .get();
    for (var doc in roomSnapshot.docs) {
      try {
        var json = doc.data();
        json['id'] = doc.id;
        var room = RoomModel.fromJson(json);
        result.add(room);
      } on FirebaseException catch (e) {
        logger.e(e.message);
      }
    }
    return result;
  }

  // Find a room
  Future<RoomModel?> getRoomByChatUesr({required String uid}) async {
    try {
      var roomSnapshot =
          await _firestore
              .collection('room')
              .where('uids', isEqualTo: [AuthHelper.user?.uid, uid])
              .get();
      var roomSnapshot1 =
          await _firestore
              .collection('room')
              .where('uids', isEqualTo: [uid, AuthHelper.user?.uid])
              .get();
      if (roomSnapshot.docs.isEmpty && roomSnapshot1.docs.isEmpty) return null;
      var doc = roomSnapshot.docs.first;
      var json = doc.data();
      json['id'] = doc.id;
      return RoomModel.fromJson(json);
    } on FirebaseException catch (e) {
      logger.e(e.message);
    }
    return null;
  }

  // Create a room
  Future<bool> createRoom(RoomModel room) async {
    try {
      await _firestore.collection('room').add({
        ...room.toJson().toFirebaseJson,
        'timestamp': FieldValue.serverTimestamp(),
        'regdate': FieldValue.serverTimestamp(),
      });
      return true;
    } on FirebaseException catch (e) {
      logger.e(e.message);
    } catch (e) {
      logger.e(e);
    }
    return false;
  }

  // Update a room
  Future<bool> updateRoom(RoomModel room) async {
    try {
      await _firestore.collection('room').doc(room.id).update({
        ...room.toJson().toFirebaseJson,
        'timestamp': FieldValue.serverTimestamp(),
      });
      return true;
    } on FirebaseException catch (e) {
      logger.e(e.message);
    } catch (e) {
      logger.e(e);
    }
    return false;
  }

  // Steam rooms
  Stream<QuerySnapshot<Map<String, dynamic>>> getRoomsStream() {
    return _firestore.collection('room').snapshots();
  }

  // Steam a room
  Stream<DocumentSnapshot<Map<String, dynamic>>> getRoomStream(String id) {
    return _firestore.collection('room').doc(id).snapshots();
  }
}
