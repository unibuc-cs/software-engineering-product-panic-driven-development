import "media_type.dart";

class Anime extends MediaType {
  // Data
  int mediaId;
  int id;
  String originalLanguage;

  Anime({
    this.id = -1,
    required this.mediaId,
    required this.originalLanguage,
  });

  @override
  bool operator ==(Object other) {
    if (runtimeType != other.runtimeType) {
      return false;
    }
    return id == (other as Anime).id;
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
    };
  }

  factory Anime.from(Map<String, dynamic> json) {
    return Anime(
      id: json["id"],
      mediaId: json["mediaid"],
      originalLanguage: json["originallanguage"],
    );
  }
}