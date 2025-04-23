import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insoblok/models/models.dart';

class StoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get messages stream
  Stream<List<StoryModel>> getMessages(String chatRoomId) {
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
}
