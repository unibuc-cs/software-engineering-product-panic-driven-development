import 'general/model.dart';
import 'general/media_type.dart';

class Manga extends MediaType implements Model {
  // Data
  int mediaId;
  int id;
  String language;
  int totalPages;
  int nrChapters;
  int nrVolumes;
  int anilistId;

  Manga({
    this.id = -1,
    required this.mediaId,
    this.language = '',
    this.totalPages = 0,
    this.nrChapters = 0,
    this.nrVolumes = 0,
    this.anilistId = -1,
  });

  static String get endpoint => 'manga';

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

  @override
  Map<String, dynamic> toJson() {
    return {
      'mediaid': mediaId,
      'language': language,
      'totalpages': totalPages,
      'nrchapters': nrChapters,
      'nrvolumes': nrVolumes,
      'anilistid': anilistId,
    };
  }

  @override
  factory Manga.from(Map<String, dynamic> json) {
    return Manga(
      id: json['id'],
      mediaId: json['mediaid'],
      language: json['language'] ?? '',
      totalPages: json['totalpages'] ?? 0,
      nrChapters: json['nrchapters'] ?? 0,
      nrVolumes: json['nrvolumes'] ?? 0,
      anilistId: json['anilistid'] ?? -1,
    );
  }
}