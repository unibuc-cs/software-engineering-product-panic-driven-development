import 'general/model.dart';

class MediaRetailer implements Model {
  // Data
  int mediaId;
  int retailerId;

  MediaRetailer({
    required this.mediaId,
    required this.retailerId,
  });

  static String get endpoint => 'mediaretailers';

  @override
  bool operator ==(Object other) {
    if (runtimeType != other.runtimeType) {
      return false;
    }
    return mediaId == (other as MediaRetailer).mediaId &&
        retailerId == other.retailerId;
  }

  @override
  int get hashCode => Object.hash(mediaId, retailerId);

  @override
  dynamic get id => [mediaId, retailerId];

  @override
  Map<String, dynamic> toJson() => {
    'mediaid'   : mediaId,
    'retailerid': retailerId,
  };

  @override
  factory MediaRetailer.from(Map<String, dynamic> json) => MediaRetailer(
    mediaId   : json['mediaid'],
    retailerId: json['retailerid'],
  );
}
