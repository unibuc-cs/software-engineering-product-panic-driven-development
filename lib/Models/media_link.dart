import 'general/model.dart';

class MediaLink implements Model {
  // Data
  int mediaId;
  int linkId;

  MediaLink({
    required this.mediaId,
    required this.linkId
  });

  static String get endpoint => 'medialinks';

  @override
  bool operator ==(Object other) {
    if (runtimeType != other.runtimeType) {
      return false;
    }
    return mediaId == (other as MediaLink).mediaId && linkId == other.linkId;
  }

  @override
  int get hashCode => Object.hash(mediaId, linkId);

  @override
  dynamic get id => [mediaId, linkId];

  @override
  Map<String, dynamic> toJson() {
    return {
      'mediaid': mediaId,
      'linkid': linkId,
    };
  }

  @override
  factory MediaLink.from(Map<String, dynamic> json) {
    return MediaLink(
      mediaId: json['mediaid'],
      linkId: json['linkid'],
    );
  }
}