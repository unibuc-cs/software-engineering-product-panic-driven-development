import "media_type.dart";

class Manga extends MediaType {
  // Data
  int mediaId;
  int id;
  String language;
  int totalPages;

  Manga({
    this.id = -1,
    required this.mediaId,
    required this.language,
    required this.totalPages,
  });

  @override
  bool operator ==(Object other) {
    if (runtimeType != other.runtimeType) {
      return false;
    }
    return id == (other as Manga).id;
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
      "language": language,
      "totalpages": totalPages,
    };
  }

  factory Manga.from(Map<String, dynamic> json) {
    return Manga(
      id: json["id"],
      mediaId: json["mediaid"],
      language: json["language"],
      totalPages: json["totalpages"],
    );
  }
}