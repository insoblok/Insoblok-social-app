class LiveSessionModel {
  final String id;
  final String userId;
  final String userName;
  final String? userAvatar;
  final String title;
  final String status;

  LiveSessionModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.title,
    required this.status,
  });

  factory LiveSessionModel.fromMap(Map<String, dynamic> map) {
    return LiveSessionModel(
      id: map['id'] as String,
      userId: map['userId'] as String? ?? '',
      userName: map['userName'] as String? ?? 'User',
      userAvatar: map['userAvatar'] as String?,
      title: map['title'] as String? ?? 'Live',
      status: map['status'] as String? ?? 'live',
    );
  }
}


