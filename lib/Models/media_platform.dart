import 'model.dart';

class MediaPlatform implements Model {
  // Data
  int mediaId;
  int platformId;

  MediaPlatform({required this.mediaId, required this.platformId});

  @override
  bool operator ==(Object other) {
    if (runtimeType != other.runtimeType) {
      return false;
    }
    return mediaId == (other as MediaPlatform).mediaId &&
        platformId == other.platformId;
  }

  @override
  int get hashCode => Object.hash(mediaId, platformId);

  @override
  Map<String, dynamic> toJson() {
    return {
      'mediaid': mediaId,
      'platformid': platformId,
    };
  }

  @override
  factory MediaPlatform.from(Map<String, dynamic> json) {
    return MediaPlatform(
      mediaId: json['mediaid'],
      platformId: json['platformid'],
    );
  }
}