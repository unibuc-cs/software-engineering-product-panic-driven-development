import "media_type.dart";

class TVSeries extends MediaType {
  // Data
  int mediaId;
  int id;
  String language;

  TVSeries({
    this.id = -1,
    required this.mediaId,
    required this.language,
  });

  @override
  bool operator ==(Object other) {
    if (runtimeType != other.runtimeType) {
      return false;
    }
    return id == (other as TVSeries).id;
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
    };
  }

  factory TVSeries.from(Map<String, dynamic> json) {
    return TVSeries(
      id: json["id"],
      mediaId: json["mediaid"],
      language: json["language"],
    );
  }
}