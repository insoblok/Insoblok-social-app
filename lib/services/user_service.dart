import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';

class UserService {
  final CollectionReference<Map<String, dynamic>> _userCollection =
      FirebaseFirestore.instance.collection('users2');

  Future<UserModel?> createUser(UserModel user) async {
    try {
      var doc = await _userCollection.add(user.toMap());
      logger.d("This is createUser ${user.toJson()}");
      return user.copyWith(id: doc.id);
    } on FirebaseException catch (e) {
      logger.e(e.message);
    } catch (e) {
      logger.e(e);
    }
    return null;
  }

  Future<UserModel?> getUser(String id) async {
    try {
      if (id.isEmpty) {
        logger.w('getUser called with empty id');
        return null;
      }
      var doc = await _userCollection.doc(id).get();
      if (!doc.exists || doc.data() == null) {
        logger.w('User document does not exist or has no data for id: $id');
        return null;
      }
      return _getUserFromDoc(doc);
    } on FirebaseException catch (e) {
      logger.e('Firebase error getting user $id: ${e.message}');
    } catch (e) {
      logger.e('Error getting user $id: ${e.toString()}');
    }
    return null;
  }

  Future<UserModel?> getUserByWalletAddress(String address) async {
    try {
      var doc = await _userCollection
          .queryBy(UserQuery.walletAddress, value: address)
          .get(const GetOptions(source: Source.server));
      if (doc.docs.isEmpty) return null;
      return _getUserFromDoc(doc.docs.first);
    } on FirebaseException catch (e) {
      logger.e(e.message);
    } catch (e) {
      logger.e(e.toString());
    }
    return null;
  }

  Future<List<UserModel?>> getAllUsers() async {
    List<UserModel?> users = [];
    var snapshot = await _userCollection.get();
    var allUsers = snapshot.docs.map((doc) => _getUserFromDoc(doc));
    for (var user in allUsers) {
      var idList = users.map((u) => u?.id).toList();
      if (idList.contains(user?.id)) {
        continue;
      }
      users.add(user);
    }

    return users.where((u) => u?.id != AuthHelper.user?.id).toList();
  }

  Future<List<String>> getFollowingUserIds({String? userid}) async {
    List<String> ids = [];
    var snapshot = await _userCollection.get();
    var allUsers = snapshot.docs.map((doc) => _getUserFromDoc(doc));
    for (var user in allUsers) {
      if (user?.follows != null &&
          user!.follows!.contains(userid ?? AuthHelper.user?.id)) {
        ids.add(user.id!);
      }
    }

    return ids;
  }

  Future<void> updateUser(UserModel user) async {
    logger.d("Updating user: ${user.toJson()}");
    await _userCollection.doc(user.id).update({...user.toMap()});
  }

  Future<void> deleteUser(UserModel user) async {
    await _userCollection.doc(user.id).delete();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserStream(String id) {
    return _userCollection.doc(id).snapshots();
  }

  Future<UserModel?> updateFollow(
    UserModel? follower,
    UserModel? followee,
  ) async {
    UserModel? newUser;
    var follows = List<String>.from(followee?.follows ?? []);
    if (follows.contains(follower?.id)) {
      follows.remove(follower?.id);
    } else {
      follows.add(follower!.id!);
    }
    try {
      newUser = followee!.copyWith(follows: follows);
      await updateUser(newUser);
    } catch (e) {
      logger.d("Failed to update follow: $e");
      return followee;
    }
    return newUser;
  }

  Future<List<UserModel?>> findUsersByKey(String key) async {
    List<UserModel?> users = [];

    var firstSnapshot =
        await _userCollection.queryBy(UserQuery.firstName, value: key).get();
    var firstUsers = firstSnapshot.docs.map((doc) => _getUserFromDoc(doc));
    for (var user in firstUsers) {
      var idList = users.map((u) => u?.id).toList();
      if (idList.contains(user?.id)) {
        continue;
      }
      users.add(user);
    }

    var lastSnapshot =
        await _userCollection.queryBy(UserQuery.lastName, value: key).get();
    var lastUsers = lastSnapshot.docs.map((doc) => _getUserFromDoc(doc));
    for (var user in lastUsers) {
      var idList = users.map((u) => u?.id).toList();
      if (idList.contains(user?.id)) {
        continue;
      }
      users.add(user);
    }

    var nickSnapshot =
        await _userCollection.queryBy(UserQuery.nickID, value: key).get();
    var nickUsers = nickSnapshot.docs.map((doc) => _getUserFromDoc(doc));
    for (var user in nickUsers) {
      var idList = users.map((u) => u?.id).toList();
      if (idList.contains(user?.id)) {
        continue;
      }
      users.add(user);
    }

    return users.where((u) => u?.id != AuthHelper.user?.id).toList();
  }

  UserModel? _getUserFromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    var json = doc.data();
    if (json != null) {
      json['id'] = doc.id;

      // Sanitize complex fields that might have incorrect types
      // Handle actions field - might contain strings instead of maps
      if (json['actions'] != null && json['actions'] is List) {
        List<dynamic> actions = json['actions'] as List;
        json['actions'] =
            actions.where((e) {
              return e is Map<String, dynamic>;
            }).toList();
      }

      // Handle galleries field - might contain strings instead of maps
      if (json['galleries'] != null && json['galleries'] is List) {
        List<dynamic> galleries = json['galleries'] as List;
        json['galleries'] =
            galleries.where((e) {
              return e is Map<String, dynamic>;
            }).toList();
      }

      // Handle socials field - might contain strings instead of maps
      if (json['socials'] != null && json['socials'] is List) {
        List<dynamic> socials = json['socials'] as List;
        json['socials'] =
            socials.where((e) {
              return e is Map<String, dynamic>;
            }).toList();
      }

      try {
        return UserModel.fromJson(json);
      } catch (e, stackTrace) {
        logger.e('Error parsing UserModel from document ${doc.id}: $e');
        logger.e('Document data: $json');
        logger.e(stackTrace);
        return null;
      }
    }
    return null;
  }

  Stream<UserModel?> getUserUpdated() {
    return _userCollection.doc('updated').snapshots().map((doc) {
      logger.d("user is updated");
      if (doc.data() == null) return null;
      return UserModel.fromJson(doc.data()!);
    });
  }
}

enum UserQuery { firstName, lastName, nickID, walletAddress }

extension on Query<Map<String, dynamic>> {
  Query<Map<String, dynamic>> queryBy(UserQuery query, {String? value}) {
    return switch (query) {
      UserQuery.firstName => where('first_name', isEqualTo: value),
      UserQuery.lastName => where('last_name', isEqualTo: value),
      UserQuery.nickID => where('nick_id', isEqualTo: value),
      UserQuery.walletAddress => where('wallet_address', isEqualTo: value),
    };
  }
}
