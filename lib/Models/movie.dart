import 'general/model.dart';
import 'general/media_type.dart';

class Movie extends MediaType implements Model {
  // Data
  int mediaId;
  int id;
  String language;
  int durationInSeconds;
  int TMDBId;

  Movie({
    this.id = -1,
    required this.mediaId,
    this.language = '',
    this.durationInSeconds = 0,
    this.TMDBId = -1,
  });

  static String get endpoint => 'movies';

  @override
  bool operator ==(Object other) {
    if (runtimeType != other.runtimeType) {
      return false;
    }
    return id == (other as Movie).id;
  }

  @override
  int getMediaId() {
    return mediaId;
  }

  @override
  int get hashCode => id;

  @override
  Map<String, dynamic> toJson() {
    return {
      'mediaid': mediaId,
      'language': language,
      'durationinseconds': durationInSeconds,
      'tmdbid': TMDBId,
    };
  }

  @override
  factory Movie.from(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      mediaId: json['mediaid'],
      language: json['language'] ?? '',
      durationInSeconds: json['durationinseconds'] ?? 0,
      TMDBId: json['tmdbid'] ?? -1,
    );
  }
}