import 'model.dart';
import 'media_type.dart';

class Movie extends MediaType implements Model {
  // Data
  int mediaId;
  int id;
  String language;
  int durationInSeconds;

  Movie({
    this.id = -1,
    required this.mediaId,
    required this.language,
    required this.durationInSeconds,
  });

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
    };
  }

  @override
  factory Movie.from(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      mediaId: json['mediaid'],
      language: json['language'],
      durationInSeconds: json['durationinseconds'],
    );
  }
}