import 'general/model.dart';

class MediaGenre implements Model {
  // Data
  int mediaId;
  int genreId;

  MediaGenre({
    required this.mediaId,
    required this.genreId,
  });

  static String get endpoint => 'mediagenres';

  @override
  bool operator ==(Object other) {
    if (runtimeType != other.runtimeType) {
      return false;
    }
    return mediaId == (other as MediaGenre).mediaId &&
           genreId == other.genreId;
  }

  @override
  int get hashCode => Object.hash(mediaId, genreId);

  @override
  dynamic get id => [mediaId, genreId];

  @override
  Map<String, dynamic> toJson() => {
    'mediaid': mediaId,
    'genreid': genreId,
  };

  @override
  factory MediaGenre.from(Map<String, dynamic> json) => MediaGenre(
    mediaId: json['mediaid'],
    genreId: json['genreid'],
  );
}
