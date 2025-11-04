enum ChatRoomType {
  private,
  group,
}

enum MessageType {
  text,
  image,
  audio,
  video,
  gif,
  file,
  paid,
  location,
  contact,
  custom,
  unsupported
}

enum MessageStatus {
  active,
  deleted,
}

enum ChatRoomStatus {
  active,
  archived,
  deleted,
}