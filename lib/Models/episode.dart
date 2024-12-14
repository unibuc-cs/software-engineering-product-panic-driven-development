import "media_type.dart";

class Episode extends MediaType {
  // Data
  int mediaId;
  int TVSeriesId;
  int seasonId;
  int id;
  int durationInSeconds;

  Episode({
    this.id = -1,
    required this.mediaId,
    required this.TVSeriesId,
    required this.seasonId,
    required this.durationInSeconds,
  });

  @override
  bool operator ==(Object other) {
    if (runtimeType != other.runtimeType) {
      return false;
    }
    return id == (other as Episode).id;
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
      "tvseriesid": TVSeriesId,
      "seasonid": seasonId,
      "durationinseconds": durationInSeconds,
    };
  }

  factory Episode.from(Map<String, dynamic> json) {
    return Episode(
      id: json["id"],
      mediaId: json["mediaid"],
      TVSeriesId: json["tvseriesid"],
      seasonId: json["seasonid"],
      durationInSeconds: json["durationinseconds"],
    );
  }
}