import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';

class StoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get stories
  Future<List<StoryModel>> getStories() async {
    List<StoryModel> result = [];
    var storiesSnapshot =
        await _firestore
            .collection('story')
            .orderBy('timestamp', descending: false)
            .get();
    for (var doc in storiesSnapshot.docs) {
      try {
        var json = doc.data();
        json['id'] = doc.id;
        var story = StoryModel.fromJson(json);
        if (story.uid != null) {
          result.add(story);
        }
      } on FirebaseException catch (e) {
        logger.e(e.message);
      }
    }
    return result;
  }

  // Get stories by uid
  Future<List<StoryModel>> getStoriesByUid(String uid) async {
    List<StoryModel> result = [];
    var storiesSnapshot =
        await _firestore
            .collection('story')
            .where('uid', isEqualTo: uid)
            .orderBy('timestamp', descending: false)
            .get();
    for (var doc in storiesSnapshot.docs) {
      try {
        var json = doc.data();
        json['id'] = doc.id;
        var story = StoryModel.fromJson(json);
        if (story.uid != null) {
          result.add(story);
        }
      } on FirebaseException catch (e) {
        logger.e(e.message);
      }
    }
    return result;
  }

  // Get stories by like
  Future<List<StoryModel>> getStoriesByLike(String uid) async {
    List<StoryModel> result = [];
    var storiesSnapshot =
        await _firestore
            .collection('story')
            .where('likes', arrayContains: uid)
            .orderBy('timestamp', descending: false)
            .get();
    for (var doc in storiesSnapshot.docs) {
      try {
        var json = doc.data();
        json['id'] = doc.id;
        var story = StoryModel.fromJson(json);
        if (story.uid != null) {
          result.add(story);
        }
      } on FirebaseException catch (e) {
        logger.e(e.message);
      }
    }
    return result;
  }

  // Get stories by follow
  Future<List<StoryModel>> getStoriesByFollow(String uid) async {
    List<StoryModel> result = [];
    var storiesSnapshot =
        await _firestore
            .collection('story')
            .where('follows', arrayContains: uid)
            .orderBy('timestamp', descending: false)
            .get();
    for (var doc in storiesSnapshot.docs) {
      try {
        var json = doc.data();
        json['id'] = doc.id;
        var story = StoryModel.fromJson(json);
        if (story.uid != null) {
          result.add(story);
        }
      } on FirebaseException catch (e) {
        logger.e(e.message);
      }
    }
    return result;
  }

  // Get stories updated
  Stream<UpdatedStoryModel> getStoryUpdated() {
    return _firestore.collection('story').doc('updated').snapshots().map((doc) {
      logger.d(doc.data());
      return UpdatedStoryModel.fromJson(doc.data()!);
    });
  }

  // Post a story
  Future<void> postStory({required StoryModel story}) async {
    await _firestore.collection('story').add({
      ...story.toJson(),
      'uid': AuthHelper.user?.uid,
      'timestamp': FieldValue.serverTimestamp(),
      'regdate': FieldValue.serverTimestamp(),
    });
    await _firestore.collection('story').doc('updated').set({
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Update like of story
  Future<void> updateLikeStory({
    required StoryModel story,
    required UserModel? user,
  }) async {
    await _firestore.collection('story').doc(story.id).update({
      ...story.toJson(),
      'regdate': FieldValue.serverTimestamp(),
    });
    if (user != null) {
      var isUpdated = false;
      var likes = List<String>.from(user.likes ?? []);
      if (story.isLike()) {
        if (!user.isLike()) {
          likes.add(AuthHelper.user!.uid!);
          isUpdated = true;
        }
      }
      if (isUpdated) {
        user = user.copyWith(likes: likes);
        await FirebaseHelper.updateUser(user);
      }
    }
  }

  // Update follow of story
  Future<void> updateFollowStory({
    required StoryModel story,
    required UserModel? user,
  }) async {
    await _firestore.collection('story').doc(story.id).update({
      ...story.toJson(),
      'regdate': FieldValue.serverTimestamp(),
    });

    if (user != null) {
      var isUpdated = false;
      var follows = List<String>.from(user.follows ?? []);
      if (story.isFollow()) {
        if (!user.isFollow()) {
          follows.add(AuthHelper.user!.uid!);
          isUpdated = true;
        }
      }
      if (isUpdated) {
        user = user.copyWith(follows: follows);
        await FirebaseHelper.updateUser(user);
      }
    }
  }

  // Add comment of story
  Future<void> addComment({required StoryModel story}) async {
    await _firestore.collection('story').doc(story.id).update({
      ...story.toJson(),
      'regdate': FieldValue.serverTimestamp(),
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
