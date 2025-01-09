import 'model.dart';

class MediaSeries implements Model {
  // Data
  int mediaId;
  int seriesId;
  double index;

  MediaSeries({
    required this.mediaId,
    required this.seriesId,
    required this.index
  });

  static String get endpoint => 'mediaseries';

  @override
  bool operator ==(Object other) {
    if (runtimeType != other.runtimeType) {
      return false;
    }
    return mediaId == (other as MediaSeries).mediaId && seriesId == other.seriesId;
  }

  @override
  int get hashCode => Object.hash(mediaId, seriesId);

  @override
  Map<String, dynamic> toJson() {
    return {
      'mediaid': mediaId,
      'seriesid': seriesId,
      'index': index,
    };
  }

  @override
  factory MediaSeries.from(Map<String, dynamic> json) {
    return MediaSeries(
      mediaId: json['mediaid'],
      seriesId: json['seriesid'],
      index: double.parse(json['index'].toString()),
    );
  }
}