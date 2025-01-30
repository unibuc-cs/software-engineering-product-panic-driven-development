import 'general/model.dart';

class MediaUserTag implements Model {
  // Data
  int mediaId;
  String userId;
  int userTagId;

  MediaUserTag({
    required this.mediaId,
    required this.userId,
    required this.userTagId,
  });

  static String get endpoint => 'mediausertags';

  @override
  bool operator ==(Object other) {
    if (runtimeType != other.runtimeType) {
      return false;
    }
    return userId == (other as MediaUserTag).userId &&
        mediaId == other.mediaId &&
        userTagId == other.userTagId;
  }

  @override
  int get hashCode => Object.hash(mediaId, userId, userTagId);

  @override
  dynamic get id => [mediaId, userTagId];

  @override
  Map<String, dynamic> toJson() => {
    'mediaid': mediaId,
    'userid' : userId,
    'tagid'  : userTagId,
  };

  @override
  factory MediaUserTag.from(Map<String, dynamic> json) => MediaUserTag(
    mediaId  : json['mediaid'],
    userId   : json['userid'],
    userTagId: json['tagid'],
  );
}
