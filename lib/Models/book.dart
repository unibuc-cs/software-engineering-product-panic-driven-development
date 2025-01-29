import 'general/model.dart';
import 'general/media_type.dart';

class Book extends MediaType implements Model {
  // Data
  int mediaId;
  int id;
  String language;
  int totalPages;
  String format;
  String goodreadsLink;

  Book({
    required this.mediaId,
    this.id            = -1,
    this.language      = '',
    this.totalPages    = 0,
    this.format        = '',
    this.goodreadsLink = '',
  });

  static String get endpoint => 'books';

  @override
  bool operator ==(Object other) {
    if (runtimeType != other.runtimeType) {
      return false;
    }
    return id == (other as Book).id;
  }

  @override
  int getMediaId() => mediaId;

  @override
  int get hashCode => id;

  @override
  Map<String, dynamic> toJson() => {
    'mediaid'      : mediaId,
    'language'     : language,
    'totalpages'   : totalPages,
    'format'       : format,
    'goodreadslink': goodreadsLink,
  };

  @override
  factory Book.from(Map<String, dynamic> json) => Book(
    id           : json['id'],
    mediaId      : json['mediaid'],
    language     : json['language'] ?? '',
    totalPages   : json['totalpages'] ?? 0,
    format       : json['format'] ?? '',
    goodreadsLink: json['goodreadslink'] ?? '',
  );
}
