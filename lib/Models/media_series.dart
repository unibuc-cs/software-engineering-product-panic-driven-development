class MediaSeries {
  // Data
  int mediaId;
  int seriesId;
  int index;

  MediaSeries({required this.mediaId, required this.seriesId, required this.index});

  @override
  bool operator ==(Object other) {
    if (runtimeType != other.runtimeType) {
      return false;
    }
    return mediaId == (other as MediaSeries).mediaId && seriesId == other.seriesId;
  }

  @override
  int get hashCode => Object.hash(mediaId, seriesId);

  Map<String, dynamic> toSupa() {
    return {
      "mediaid": mediaId,
      "seriesid": seriesId,
      "index": index,
    };
  }

  factory MediaSeries.from(Map<String, dynamic> json) {
    return MediaSeries(
      mediaId: json["mediaid"],
      seriesId: json["seriesid"],
      index: json["index"],
    );
  }
}