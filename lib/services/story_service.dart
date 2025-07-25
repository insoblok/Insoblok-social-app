import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';

class StoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference<Map<String, dynamic>> get storyCollection =>
      _firestore.collection('story');

  Future<StoryModel> getStory(String id) async {
    var doc = await storyCollection.doc(id).get();
    return StoryModel.fromJson({'id': doc.id, ...(doc.data() ?? {})});
  }

  // Get stories
  Future<List<StoryModel>> getStories() async {
    List<StoryModel> result = [];
    var storiesSnapshot =
        await storyCollection.orderBy('timestamp', descending: true).get();
    for (var doc in storiesSnapshot.docs) {
      try {
        var json = doc.data();
        json['id'] = doc.id;
        var story = StoryModel.fromJson(json);
        if (story.userId != null) {
          result.add(story);
        }
      } on FirebaseException catch (e) {
        logger.e(e.message);
      }
    }
    return result;
  }

  // Get following stories
  Future<List<StoryModel>> getFollowingStories() async {
    List<StoryModel> result = [];
    var storiesSnapshot =
        await storyCollection.orderBy('timestamp', descending: true).get();
    var userIds = await userService.getFollowingUserIds();
    for (var doc in storiesSnapshot.docs) {
      try {
        var json = doc.data();
        json['id'] = doc.id;
        var story = StoryModel.fromJson(json);
        if (story.userId != null && userIds.contains(story.userId)) {
          result.add(story);
        }
      } on FirebaseException catch (e) {
        logger.e(e.message);
      }
    }
    return result;
  }

  // Get lookbook stories
  Future<List<StoryModel>> getLookBookStories() async {
    List<StoryModel> result = [];
    var storiesSnapshot =
        await storyCollection.orderBy('timestamp', descending: true).get();
    for (var doc in storiesSnapshot.docs) {
      try {
        var json = doc.data();
        json['id'] = doc.id;
        var story = StoryModel.fromJson(json);
        if (story.userId != null &&
            AuthHelper.user!.userActions != null &&
            AuthHelper.user!.userActions!.contains(story.id)) {
          result.add(story);
        }
      } on FirebaseException catch (e) {
        logger.e(e.message);
      }
    }
    return result;
  }

  // Get stories by id
  Future<List<StoryModel>> getStoriesById(String id) async {
    List<StoryModel> result = [];
    var storiesSnapshot =
        await storyCollection
            .where('user_id', isEqualTo: id)
            .orderBy('timestamp', descending: false)
            .get();
    for (var doc in storiesSnapshot.docs) {
      try {
        var json = doc.data();
        json['id'] = doc.id;
        var story = StoryModel.fromJson(json);
        if (story.userId != null) {
          result.add(story);
        }
      } on FirebaseException catch (e) {
        logger.e(e.message);
      }
    }
    return result
      ..sort((b, a) => a.timestamp!.difference(b.timestamp!).inSeconds);
  }

  // Get stories by like
  Future<List<StoryModel>> getStoriesByLike(String id) async {
    List<StoryModel> result = [];
    var storiesSnapshot =
        await storyCollection
            .where('likes', arrayContains: id)
            .orderBy('timestamp', descending: false)
            .get();
    for (var doc in storiesSnapshot.docs) {
      try {
        var json = doc.data();
        json['id'] = doc.id;
        var story = StoryModel.fromJson(json);
        if (story.userId != null) {
          result.add(story);
        }
      } on FirebaseException catch (e) {
        logger.e(e.message);
      }
    }
    return result;
  }

  // Get stories by follow
  Future<List<StoryModel>> getStoriesByFollow(String id) async {
    List<StoryModel> result = [];
    var storiesSnapshot =
        await storyCollection
            .where('follows', arrayContains: id)
            .orderBy('timestamp', descending: false)
            .get();
    for (var doc in storiesSnapshot.docs) {
      try {
        var json = doc.data();
        json['id'] = doc.id;
        var story = StoryModel.fromJson(json);
        if (story.userId != null) {
          result.add(story);
        }
      } on FirebaseException catch (e) {
        logger.e(e.message);
      }
    }
    return result;
  }

  // Get stories updated
  Stream<UpdatedStoryModel?> getStoryUpdated() {
    return storyCollection.doc('updated').snapshots().map((doc) {
      logger.d(doc.data());
      if (doc.data() == null) return null;
      return UpdatedStoryModel.fromJson(doc.data()!);
    });
  }

  final tastescoreService = TastescoreService();

  // Post a story
  Future<String> postStory({required StoryModel story}) async {
    var ref = await storyCollection.add({
      ...story.toMap(),
      'user_id': AuthHelper.user?.id,
    });

    await storyCollection.doc('updated').set({
      'timestamp': DateTime.now().toUtc().toIso8601String(),
    });

    // check for win_creator xp
    if ((!(AuthHelper.user?.hasVotePost ?? false)) &&
        (story.category == 'vote')) {
      await tastescoreService.winCreatorScore();
      await AuthHelper.updateUser(AuthHelper.user!.copyWith(hasVotePost: true));
    }
    if (story.status != null && story.status == 'private') {
      addUserAction(ref.id);
    }
    return ref.id;
  }

  // Update a story
  Future<void> updateStory({required StoryModel story}) async {
    await storyCollection.doc(story.id).update(story.toMap());
    // check for win_creator xp
    if ((!(AuthHelper.user?.hasVotePost ?? false)) &&
        (story.category == 'vote')) {
      await tastescoreService.winCreatorScore();
      await AuthHelper.updateUser(AuthHelper.user!.copyWith(hasVotePost: true));
    }
  }

  // Update a story
  Future<void> updateStoryById({
    required String id,
    Map<String, dynamic>? data,
  }) async {
    if (data == null) return;
    await storyCollection.doc(id).update(data);
  }

  final _userService = UserService();
  UserService get userService => _userService;

  // Update like of story
  Future<void> updateLikeStory({
    required StoryModel story,
    required UserModel? user,
  }) async {
    await storyCollection.doc(story.id).update(story.toMap());
    if (user != null) {
      var isUpdated = false;
      var likes = List<String>.from(user.likes ?? []);
      if (story.isLike()) {
        if (!user.isLike()) {
          likes.add(AuthHelper.user!.id!);
          isUpdated = true;
        }
      }
      if (isUpdated) {
        user = user.copyWith(likes: likes);
        await userService.updateUser(user);
      }
    }
    addUserAction(story.id!);
  }

  // Update follow of story
  Future<void> updateFollowStory({
    required StoryModel story,
    required UserModel? user,
  }) async {
    await storyCollection.doc(story.id).update(story.toMap());

    if (user != null) {
      var isUpdated = false;
      var follows = List<String>.from(user.follows ?? []);
      if (story.isFollow()) {
        if (!user.isFollow()) {
          follows.add(AuthHelper.user!.id!);
          isUpdated = true;
        }
      }
      if (isUpdated) {
        user = user.copyWith(follows: follows);
        await userService.updateUser(user);
      }
    }
    addUserAction(story.id!);
  }

  // Update vote of story
  Future<void> updateVoteStory({
    required StoryModel story,
    required UserModel? user,
    required bool? isVote,
  }) async {
    await storyCollection.doc(story.id).update(story.toMap());

    if (user != null) {
      var votes = List<UserActionModel>.from(user.actions ?? []);
      var index = votes.indexWhere(
        (vote) =>
            vote.postUserId == AuthHelper.user?.id && vote.postId == story.id,
      );

      if (index == -1) {
        votes.add(
          UserActionModel(
            postId: story.id,
            postUserId: AuthHelper.user!.id!,
            value: isVote,
            type: 'vote',
          ),
        );
      } else {
        votes[index] = UserActionModel(
          postId: story.id,
          postUserId: AuthHelper.user!.id!,
          value: isVote,
          type: 'vote',
        );
      }
      user = user.copyWith(actions: votes);
      await userService.updateUser(user);

      addUserAction(story.id!);
    }
  }

  // Add comment of story
  Future<void> addComment({required StoryModel story}) async {
    await storyCollection.doc(story.id).update(story.toMap());
    addUserAction(story.id!);
  }

  Future<void> addUserAction(String storyId) async {
    var owner = AuthHelper.user;
    var userActions = List<String>.from(owner?.userActions ?? []);
    var actionIndex = userActions.indexWhere((action) => action == storyId);
    if (actionIndex == -1) {
      userActions.add(storyId);
    } else {
      userActions[actionIndex] = storyId;
    }
    owner = owner!.copyWith(userActions: userActions);
    await AuthHelper.updateUser(owner);
  }

  Future<String?> uploadResult(String url, {String? folderName}) async {
    return FirebaseHelper.uploadImageFromUrl(
      imageUrl: url,
      folderName: folderName,
    );
  }
}
