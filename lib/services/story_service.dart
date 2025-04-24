import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

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

  // Post a story
  Future<void> postStory({required StoryModel story}) async {
    await _firestore
        .collection('story')
        .add(
          story
              .copyWith(
                uid: AuthHelper.user?.uid,
                regdate: kFullDateTimeFormatter.format(DateTime.now().toUtc()),
                timestamp: kFullDateTimeFormatter.format(
                  DateTime.now().toUtc(),
                ),
              )
              .toMap(),
        );
    await _firestore.collection('story').doc('updated').set({
      'timestamp': kFullDateTimeFormatter.format(DateTime.now().toUtc()),
    });
  }

  // Get updated
  Stream<UpdatedStoryModel> getStoryUpdated() {
    return _firestore.collection('story').doc('updated').snapshots().map((doc) {
      logger.d(doc.data());
      return UpdatedStoryModel.fromJson(doc.data()!);
    });
  }
}
