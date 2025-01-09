import 'model.dart';
import 'media_type.dart';

class TVSeries extends MediaType implements Model {
  // Data
  int mediaId;
  int id;
  String language;

  TVSeries({
    this.id = -1,
    required this.mediaId,
    this.language = '',
  });

  static String get endpoint => 'tvseries';

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

  @override
  Map<String, dynamic> toJson() {
    return {
      'mediaid': mediaId,
      'language': language,
    };
  }

  @override
  factory TVSeries.from(Map<String, dynamic> json) {
    return TVSeries(
      id: json['id'],
      mediaId: json['mediaid'],
      language: json['language'] ?? '',
    );
  }
}