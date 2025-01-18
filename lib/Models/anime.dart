import 'general/model.dart';
import 'general/media_type.dart';

class Anime extends MediaType implements Model {
  // Data
  int mediaId;
  int id;
  String language;
  int anilistId;

  Anime({
    this.id = -1,
    required this.mediaId,
    this.language = '',
    this.anilistId = -1,
  });

  static String get endpoint => 'anime';

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

  @override
  Map<String, dynamic> toJson() {
    return {
      'mediaid': mediaId,
      'language': language,
      'anilistid': anilistId,
    };
  }

  @override
  factory Anime.from(Map<String, dynamic> json) {
    return Anime(
      id: json['id'],
      mediaId: json['mediaid'],
      language: json['language'] ?? '',
      anilistId: json['anilistid'] ?? -1,
    );
  }
}