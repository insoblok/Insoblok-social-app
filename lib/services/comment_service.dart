import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';

class CommentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference<Map<String, dynamic>> get commentCollection =>
      _firestore.collection('comment');

  Future<String> postComment({required StoryCommentModel comment}) async {
    var ref = await commentCollection.add({
      ...comment.toMap(),
      'user_id': AuthHelper.user?.id,
    });

    await commentCollection.doc('updated').set({
      'timestamp': DateTime.now().toUtc().toIso8601String(),
    });

    addUserAction(ref.id);
    return ref.id;
  }

  // Get stories
  Future<List<StoryCommentModel>> getComments(String storyId) async {
    List<StoryCommentModel> result = [];
    var snapshot =
        await commentCollection
            .where('story_id', isEqualTo: storyId)
            .orderBy('timestamp', descending: true)
            .get();
    for (var doc in snapshot.docs) {
      try {
        var json = doc.data();
        json['id'] = doc.id;
        var comment = StoryCommentModel.fromJson(json);
        if (comment.userId != null) {
          result.add(comment);
        }
      } on FirebaseException catch (e) {
        logger.e(e.message);
      }
    }
    return result;
  }

  Future<void> updateLikeComment({required StoryCommentModel comment}) async {
    await commentCollection.doc(comment.id).update(comment.toMap());

    addUserAction(comment.id!);
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
  }
}
