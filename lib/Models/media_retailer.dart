import 'model.dart';

class MediaRetailer implements Model {
  // Data
  int mediaId;
  int retailerId;

  MediaRetailer({required this.mediaId, required this.retailerId});

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
  Map<String, dynamic> toJson() {
    return {
      'mediaid': mediaId,
      'retailerid': retailerId,
    };
  }

  @override
  factory MediaRetailer.from(Map<String, dynamic> json) {
    return MediaRetailer(
      mediaId: json['mediaid'],
      retailerId: json['retailerid'],
    );
  }
}