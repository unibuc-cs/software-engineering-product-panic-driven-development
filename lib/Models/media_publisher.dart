import 'general/model.dart';

class MediaPublisher implements Model {
  // Data
  int mediaId;
  int publisherId;

  MediaPublisher({
    required this.mediaId,
    required this.publisherId,
  });

  static String get endpoint => 'mediapublishers';

  @override
  bool operator ==(Object other) {
    if (runtimeType != other.runtimeType) {
      return false;
    }
    return mediaId == (other as MediaPublisher).mediaId &&
           publisherId == other.publisherId;
  }

  @override
  int get hashCode => Object.hash(mediaId, publisherId);

  @override
  dynamic get id => [mediaId, publisherId];

  @override
  Map<String, dynamic> toJson() => {
    'mediaid'    : mediaId,
    'publisherid': publisherId,
  };

  @override
  factory MediaPublisher.from(Map<String, dynamic> json) => MediaPublisher(
    mediaId    : json['mediaid'],
    publisherId: json['publisherid'],
  );
}
