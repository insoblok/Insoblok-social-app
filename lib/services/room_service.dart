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
            // .orderBy('timestamp', descending: false)
            .where('user_ids', arrayContains: AuthHelper.user?.id)
            .get();
    for (var doc in roomSnapshot.docs) {
      try {
        var json = doc.data();
        json['id'] = doc.id;
        var room = RoomModel.fromJson(json);
        if (room.userId != null &&
            room.userIds!.contains(AuthHelper.user?.id)) {
          result.add(room);
        }
      } on FirebaseException catch (e) {
        logger.e(e.message);
      }
    }
    return result;
  }

  // Get rooms with pagination
  Future<QuerySnapshot<Map<String, dynamic>>> getRoomsPage({
    required int limit,
    DocumentSnapshot<Map<String, dynamic>>? startAfter,
  }) async {
    Query<Map<String, dynamic>> baseQuery = _firestore
        .collection('room')
        .where('user_ids', arrayContains: AuthHelper.user?.id)
        // Avoid composite index requirement; sort client-side by update_date
        .orderBy(FieldPath.documentId);

    if (startAfter != null) {
      baseQuery = baseQuery.startAfterDocument(startAfter);
    }

    return await baseQuery.limit(limit).get();
  }

  // Find a room
  Future<RoomModel?> getRoomByChatUesr({required String id}) async {
    try {
      var roomSnapshot =
          await _firestore
              .collection('room')
              .where('user_ids', isEqualTo: [AuthHelper.user?.id, id])
              .get();
      var roomSnapshot1 =
          await _firestore
              .collection('room')
              .where('user_ids', isEqualTo: [id, AuthHelper.user?.id])
              .get();
      if (roomSnapshot.docs.isEmpty && roomSnapshot1.docs.isEmpty) return null;
      var doc =
          roomSnapshot.docs.isNotEmpty
              ? roomSnapshot.docs.first
              : roomSnapshot1.docs.first;
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
      await _firestore.collection('room').add(room.toMap());
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
      await _firestore.collection('room').doc(room.id).update(room.toMap());
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
