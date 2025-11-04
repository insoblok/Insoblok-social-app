import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';

class ChatRoomWithSettings {
  final RoomModel chatroom;
  final UserChatRoomModel userSettings;

  ChatRoomWithSettings({required this.chatroom, required this.userSettings});

  // Helper getters for convenience
  bool get isArchived => userSettings.isArchived ?? false;
  bool get isDeleted => userSettings.isDeleted ?? false;
  bool get isMuted => userSettings.isMuted ?? false;
  bool get isActive => !isArchived && !isDeleted;

  String get id => chatroom.id ?? '';
  DateTime? get updatedAt => chatroom.updatedAt;
}

class RoomService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final Stream<List<ChatRoomWithSettings>> _allChatroomsStream;
  final int _maxWhereInLimit = 30;

  // Get rooms
  RoomService(String? userId) {
    _allChatroomsStream = _createAllChatroomsStream(userId ?? "");
  }
  Future<List<RoomModel>> getRooms() async {
    List<RoomModel> result = [];
    var roomSnapshot =
        await _firestore
            .collection('chatRooms')
            // .orderBy('timestamp', descending: false)
            .where('user_ids', arrayContains: AuthHelper.user?.id)
            .get();
    logger.d("THis is from firebase $roomSnapshot");
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
        .collection('chatRooms')
        .where('user_ids', arrayContains: AuthHelper.user?.id)
        // Avoid composite index requirement; sort client-side by update_date
        .orderBy(FieldPath.documentId);

    if (startAfter != null) {
      baseQuery = baseQuery.startAfterDocument(startAfter);
    }

    return await baseQuery.limit(limit).get();
  }

  // Find a room
  Future<RoomModel?> getRoomByChatUser({required String id}) async {
    try {
      final currentUserId = AuthHelper.user?.id;
      if (currentUserId == null || currentUserId.isEmpty) {
        logger.e("Current user ID is null or empty");
        return null;
      }

      // Query rooms where current user is in the user_ids array
      var roomSnapshot =
          await _firestore
              .collection('chatRooms')
              .where('user_ids', arrayContains: currentUserId)
              .get();

      if (roomSnapshot.docs.isEmpty) {
        logger.d("No rooms found for current user");
        return null;
      }

      // Filter client-side to find room where both users are present
      for (var doc in roomSnapshot.docs) {
        var json = doc.data();
        var userIds = json['user_ids'] as List?;

        if (userIds != null &&
            userIds.contains(currentUserId) &&
            userIds.contains(id)) {
          json['id'] = doc.id;
          logger.d("Found room with ID: ${doc.id}");
          return RoomModel.fromJson(json);
        }
      }

      logger.d("No room found with both users");
      return null;
    } on FirebaseException catch (e) {
      logger.e(
        "Firebase error in getRoomByChatUser: ${e.message}, code: ${e.code}",
      );
      return null;
    } catch (e) {
      logger.e("Error in getRoomByChatUser: $e");
      return null;
    }
  }

  // Create a room
  Future<String> createRoom(RoomModel room) async {
    try {
      DocumentReference docRef = await _firestore
          .collection('chatRooms')
          .add(room.toJson());
      await _firestore.collection('userChatRooms').add({
        "user_id": AuthHelper.user?.id,
        "room_id": docRef.id,
        'is_archived': false,
        'is_muted': false,
        'is_deleted': false,
        'unread_count': 0,
      });
      return docRef.id;
    } on FirebaseException catch (e) {
      logger.e(e.message);
    } catch (e) {
      logger.e(e);
    }
    return "";
  }

  // Update a room
  Future<bool> updateRoom(RoomModel room) async {
    try {
      await _firestore
          .collection('chatRooms')
          .doc(room.id)
          .update(room.toJson());
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
    return _firestore.collection('chatRooms').snapshots();
  }

  // Steam a room
  Stream<DocumentSnapshot<Map<String, dynamic>>> getRoomStream(String id) {
    return _firestore.collection('chatRooms').doc(id).snapshots();
  }

  Future<bool> archive(String userId, Set<String> roomIds) async {
    if (userId.isEmpty || roomIds.isEmpty) return false;
    final batch = _firestore.batch();
    try {
      final userChatroomRef =
          await _firestore
              .collection("userChatRooms")
              .where("room_id", whereIn: roomIds)
              .where("user_id", isEqualTo: userId)
              .get();
      for (final doc in userChatroomRef.docs) {
        batch.set(doc.reference, {
          'is_archived': true,
          'archived_at': FieldValue.serverTimestamp(),
          'updated_at': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }

      await batch.commit();
      return true;
    } catch (e) {
      logger.e("❌ Error archiving multiple rooms: $e");

      return false;
    }
  }

  Future<bool> unArchive(String userId, Set<String> roomIds) async {
    final batch = _firestore.batch();
    try {
      final userChatroomRef =
          await _firestore
              .collection("userChatRooms")
              .where("room_id", whereIn: roomIds)
              .where("user_id", isEqualTo: userId)
              .get();
      for (final doc in userChatroomRef.docs) {
        batch.set(doc.reference, {
          'is_archived': false,
          'updated_at': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }

      await batch.commit();
      return true;
    } catch (e) {
      logger.e("❌ Error archiving multiple rooms: $e");

      return false;
    }
  }

  Future<bool> deleteRooms(String userId, Set<String> roomIds) async {
    final batch = _firestore.batch();
    try {
      final userChatroomRef =
          await _firestore
              .collection("userChatRooms")
              .where("room_id", whereIn: roomIds)
              .where("user_id", isEqualTo: userId)
              .get();
      for (final doc in userChatroomRef.docs) {
        batch.set(doc.reference, {
          'is_deleted': true,
          'updated_at': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }

      await batch.commit();
      return true;
    } catch (e) {
      logger.e("❌ Error archiving multiple rooms: $e");

      return false;
    }
  }

  Future<bool> muteRooms(String userId, Set<String> roomIds) async {
    final batch = _firestore.batch();
    try {
      final userChatroomRef =
          await _firestore
              .collection("userChatRooms")
              .where("room_id", whereIn: roomIds)
              .where("user_id", isEqualTo: userId)
              .get();
      for (final doc in userChatroomRef.docs) {
        batch.set(doc.reference, {
          'is_muted': true,
          'muted_at': FieldValue.serverTimestamp(),
          'updated_at': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }

      await batch.commit();
      return true;
    } catch (e) {
      logger.e("❌ Error archiving multiple rooms: $e");

      return false;
    }
  }

  Future<bool> unMuteRooms(String userId, Set<String> roomIds) async {
    final batch = _firestore.batch();
    try {
      final userChatroomRef =
          await _firestore
              .collection("userChatRooms")
              .where("room_id", whereIn: roomIds)
              .where("user_id", isEqualTo: userId)
              .get();
      for (final doc in userChatroomRef.docs) {
        batch.set(doc.reference, {
          'is_muted': false,
          'updated_at': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }

      await batch.commit();
      return true;
    } catch (e) {
      logger.e("❌ Error archiving multiple rooms: $e");
      return false;
    }
  }

  Stream<List<ChatRoomWithSettings>> getActiveChatrooms() {
    return _allChatroomsStream.map(
      (chatrooms) =>
          chatrooms
              .where(
                (cws) =>
                    !(cws.userSettings.isArchived ?? false) &&
                    !(cws.userSettings.isDeleted ?? false),
              )
              .toList(),
    );
  }

  Stream<List<ChatRoomWithSettings>> getArchivedChatrooms() {
    return _allChatroomsStream.map(
      (rooms) =>
          rooms.where((cws) {
            return (cws.userSettings.isArchived ?? false) &&
                !(cws.userSettings.isDeleted ?? false);
          }).toList(),
    );
  }

  Stream<List<ChatRoomWithSettings>> getDeletedChatrooms() {
    return _allChatroomsStream.map(
      (rooms) =>
          rooms.where((cws) => cws.userSettings.isDeleted ?? false).toList(),
    );
  }

  Stream<List<ChatRoomWithSettings>> getMutedChatrooms() {
    return _allChatroomsStream.map(
      (rooms) =>
          rooms.where((cws) => cws.userSettings.isMuted ?? false).toList(),
    );
  }

  Stream<List<ChatRoomWithSettings>> _createAllChatroomsStream(String userId) {
    final roomsStream =
        _firestore
            .collection('chatRooms')
            .where('user_ids', arrayContains: userId)
            .snapshots();

    final userSettingsStream =
        _firestore
            .collection('userChatRooms')
            .where('user_id', isEqualTo: userId)
            .snapshots();

    return roomsStream.switchMap((roomsSnapshot) {
      return userSettingsStream.map((settingsSnapshot) {
        final rooms =
            roomsSnapshot.docs.map((doc) {
              var data = doc.data();
              data['id'] = doc.id;
              return RoomModel.fromJson(data);
            }).toList();

        final userSettings = <String, UserChatRoomModel>{};
        for (final doc in settingsSnapshot.docs) {
          final data = doc.data();
          data['id'] = doc.id;
          final setting = UserChatRoomModel.fromJson(data);
          userSettings[setting.roomId ?? ''] = setting;
        }

        return rooms.map((room) {
          final settings =
              userSettings[room.id] ??
              _createDefaultSettings(room.id ?? '', userId);
          return ChatRoomWithSettings(chatroom: room, userSettings: settings);
        }).toList();
      });
    }).asBroadcastStream();
  }

  Future<Map<String, UserChatRoomModel>> _getUserChatroomSettings(
    List<String> roomIds,
    String userId,
  ) async {
    if (roomIds.isEmpty || userId.isEmpty) return {};
    logger.d("This is _getUserChatRoomSettings");
    final userSettingsSnapshot =
        await _firestore
            .collection('userChatRooms')
            .where('room_id', whereIn: roomIds)
            .where('user_id', isEqualTo: userId)
            .get();

    final Map<String, UserChatRoomModel> userSettings = {};
    for (final doc in userSettingsSnapshot.docs) {
      final data = doc.data();
      data['id'] = doc.id;
      final setting = UserChatRoomModel.fromJson(data);
      userSettings[setting.roomId ?? ''] = setting;
    }

    return userSettings;
  }

  UserChatRoomModel _createDefaultSettings(String roomId, String userId) {
    return UserChatRoomModel(
      userId: userId,
      roomId: roomId,
      isArchived: false,
      isMuted: false,
      isDeleted: false,
      unreadCount: 0,
    );
  }

  List<List<T>> _chunkList<T>(List<T> list, int chunkSize) {
    final chunks = <List<T>>[];
    for (var i = 0; i < list.length; i += chunkSize) {
      final end = i + chunkSize > list.length ? list.length : i + chunkSize;
      chunks.add(list.sublist(i, end));
    }
    return chunks;
  }
}
