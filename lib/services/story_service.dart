import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/utils/utils.dart';

class StoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get stories stream
  Stream<List<StoryModel>> getStories(String chatRoomId) {
    return _firestore
        .collection('story')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) {
                var data = doc.data();
                data['id'] = doc.id;
                return StoryModel.fromJson(data);
              }).toList(),
        );
  }

  // Post a story
  Future<void> postStory({required StoryModel story}) async {
    await _firestore
        .collection('story')
        .add(
          story
              .copyWith(
                timestamp: kFullDateTimeFormatter.format(
                  DateTime.now().toUtc(),
                ),
              )
              .toJson(),
        );
  }
}
