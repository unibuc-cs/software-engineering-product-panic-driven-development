import 'general/model.dart';

class MediaUserSource implements Model {
  // Data
  int mediaId;
  String userId;
  int sourceId;

  MediaUserSource({
    required this.mediaId,
    required this.userId,
    required this.sourceId
  });

  static String get endpoint => 'mediausersources';

  @override
  bool operator ==(Object other) {
    if (runtimeType != other.runtimeType) {
      return false;
    }
    return userId == (other as MediaUserSource).userId &&
           mediaId == other.mediaId &&
           sourceId == other.sourceId;
  }

  @override
  int get hashCode => Object.hash(mediaId, userId, sourceId);

  @override
  dynamic get id => [mediaId, sourceId];

  @override
  Map<String, dynamic> toJson() => {
    'mediaid' : mediaId,
    'userid'  : userId,
    'sourceid': sourceId,
  };
  

  @override
  factory MediaUserSource.from(Map<String, dynamic> json) => MediaUserSource(
    mediaId : json['mediaid'],
    userId  : json['userid'],
    sourceId: json['sourceid'],
  );
}