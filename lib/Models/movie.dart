import "media_type.dart";

class Movie extends MediaType {
  // Data
  int mediaId;
  int id;
  String originalLanguage;
  int durationInSeconds;

  Movie({
    this.id = -1,
    required this.mediaId,
    required this.originalLanguage,
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

  Map<String, dynamic> toSupa() {
    return {
      "mediaid": mediaId,
      "originallanguage": originalLanguage,
      "durationinseconds": durationInSeconds,
    };
  }

  factory Movie.from(Map<String, dynamic> json) {
    return Movie(
      id: json["id"],
      mediaId: json["mediaid"],
      originalLanguage: json["originallanguage"],
      durationInSeconds: json["durationinseconds"],
    );
  }
}