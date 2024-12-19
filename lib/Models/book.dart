import 'model.dart';
import 'media_type.dart';

class Book extends MediaType implements Model {
  // Data
  int mediaId;
  int id;
  String language;
  int totalPages;
  String format;

  Book({
    this.id = -1,
    required this.mediaId,
    required this.language,
    required this.totalPages,
    required this.format,
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

  @override
  Map<String, dynamic> toJson() {
    return {
      'mediaid': mediaId,
      'language': language,
      'totalpages': totalPages,
      'format': format,
    };
  }

  @override
  factory Book.from(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      mediaId: json['mediaid'],
      language: json['language'],
      totalPages: json['totalpages'],
      format: json['format'],
    );
  }
}