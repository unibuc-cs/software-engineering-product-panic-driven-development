import 'model.dart';

class MediaCreator implements Model {
  // Data
  int mediaId;
  int creatorId;

  MediaCreator({required this.mediaId, required this.creatorId});

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