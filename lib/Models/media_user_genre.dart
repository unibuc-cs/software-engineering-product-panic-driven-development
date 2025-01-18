import 'general/model.dart';

class MediaUserGenre implements Model {
  // Data
  int mediaId;
  String userId;
  int genreId;

  MediaUserGenre({
    required this.mediaId,
    required this.userId,
    required this.genreId
  });

  static String get endpoint => 'mediausergenres';

  @override
  bool operator ==(Object other) {
    if (runtimeType != other.runtimeType) {
      return false;
    }
    return mediaId == (other as MediaUserGenre).mediaId &&
        userId == other.userId &&
        genreId == other.genreId;
  }

  @override
  int get hashCode => Object.hash(mediaId, userId, genreId);

  @override
  dynamic get id => [mediaId, genreId];

  @override
  Map<String, dynamic> toJson() {
    return {
      'mediaid': mediaId,
      'userid': userId,
      'genreid': genreId,
    };
  }

  @override
  factory MediaUserGenre.from(Map<String, dynamic> json) {
    return MediaUserGenre(
      mediaId: json['mediaid'],
      userId: json['userid'],
      genreId: json['genreid'],
    );
  }
}