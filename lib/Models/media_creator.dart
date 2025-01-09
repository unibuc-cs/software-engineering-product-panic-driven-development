import 'general/model.dart';

class MediaCreator implements Model {
  // Data
  int mediaId;
  int creatorId;

  MediaCreator({
    required this.mediaId,
    required this.creatorId
  });

  static String get endpoint => 'mediacreators';

  @override
  bool operator ==(Object other) {
    if (runtimeType != other.runtimeType) {
      return false;
    }
    return mediaId == (other as MediaCreator).mediaId &&
        creatorId == other.creatorId;
  }

  @override
  int get hashCode => Object.hash(mediaId, creatorId);

  @override
  dynamic get id => [mediaId, creatorId];

  @override
  Map<String, dynamic> toJson() {
    return {
      'mediaid': mediaId,
      'creatorid': creatorId,
    };
  }

  @override
  factory MediaCreator.from(Map<String, dynamic> json) {
    return MediaCreator(
      mediaId: json['mediaid'],
      creatorId: json['creatorid'],
    );
  }
}