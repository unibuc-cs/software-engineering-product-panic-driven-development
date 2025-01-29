import 'general/model.dart';
import 'general/media_type.dart';

class TVSeries extends MediaType implements Model {
  // Data
  int mediaId;
  int id;
  String language;
  int TMDBId;

  TVSeries({
    required this.mediaId,
    this.id       = -1,
    this.language = '',
    this.TMDBId   = -1,
  });

  static String get endpoint => 'tvseries';

  @override
  bool operator ==(Object other) {
    if (runtimeType != other.runtimeType) {
      return false;
    }
    return id == (other as TVSeries).id;
  }

  @override
  int getMediaId() => mediaId;

  @override
  int get hashCode => id;

  @override
  Map<String, dynamic> toJson() => {
    'mediaid' : mediaId,
    'language': language,
    'tmdbid'  : TMDBId,
  };

  @override
  factory TVSeries.from(Map<String, dynamic> json) => TVSeries(
    id      : json['id'],
    mediaId : json['mediaid'],
    language: json['language'] ?? '',
    TMDBId  : json['tmdbid'] ?? -1,
  );
}
