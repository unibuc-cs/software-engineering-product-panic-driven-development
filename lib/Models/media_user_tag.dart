import 'general/model.dart';

class MediaUserTag implements Model {
  // Data
  int mediaId;
  String userId;
  int tagId;

  MediaUserTag({
    required this.mediaId,
    required this.userId,
    required this.tagId
  });

  static String get endpoint => 'mediausertags';

  @override
  bool operator ==(Object other) {
    if (runtimeType != other.runtimeType) {
      return false;
    }
    return userId == (other as MediaUserTag).userId &&
        mediaId == other.mediaId &&
        tagId == other.tagId;
  }

  @override
  int get hashCode => Object.hash(mediaId, userId, tagId);

  @override
  dynamic get id => [mediaId, tagId];

  @override
  Map<String, dynamic> toJson() {
    return {
      'mediaid': mediaId,
      'userid': userId,
      'tagid': tagId,
    };
  }

  @override
  factory MediaUserTag.from(Map<String, dynamic> json) {
    return MediaUserTag(
      mediaId: json['mediaid'],
      userId: json['userid'],
      tagId: json['tagid'],
    );
  }
}