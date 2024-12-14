import "media_type.dart";

class Book extends MediaType {
  // Data
  int mediaId;
  int id;
  String originalLanguage;
  int totalPages;

  Book({
    this.id = -1,
    required this.mediaId,
    required this.originalLanguage,
    required this.totalPages,
  });

  @override
  bool operator ==(Object other) {
    if (runtimeType != other.runtimeType) {
      return false;
    }
    return id == (other as Book).id;
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
      "totalpages": totalPages,
    };
  }

  factory Book.from(Map<String, dynamic> json) {
    return Book(
      id: json["id"],
      mediaId: json["mediaid"],
      originalLanguage: json["originallanguage"],
      totalPages: json["totalpages"],
    );
  }
}