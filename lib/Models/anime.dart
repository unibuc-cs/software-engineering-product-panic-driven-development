import 'general/model.dart';
import 'general/media_type.dart';

class Anime extends MediaType implements Model {
  // Data
  int mediaId;
  int id;
  String language;
  int nrEpisodes;
  int episodeDuration;
  int anilistId;

  Anime({
    this.id = -1,
    required this.mediaId,
    this.language = '',
    this.nrEpisodes = 0,
    this.episodeDuration = 0,
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
      'nrepisodes': nrEpisodes,
      'episodeduration': episodeDuration,
      'anilistid': anilistId,
    };
  }

  @override
  factory Anime.from(Map<String, dynamic> json) {
    return Anime(
      id: json['id'],
      mediaId: json['mediaid'],
      language: json['language'] ?? '',
      nrEpisodes: json['nrepisodes'] ?? 0,
      episodeDuration: json['episodeduration'] ?? 0,
      anilistId: json['anilistid'] ?? -1,
    );
  }
}