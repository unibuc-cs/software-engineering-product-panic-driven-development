import 'general/model.dart';

class Source implements Model {
  // Data
  int id;
  String name;
  String mediaType;

  Source({
    this.id = -1,
    required this.name,
    required this.mediaType,
  });

  static String get endpoint => 'sources';

  @override
  bool operator ==(Object other) {
    if (runtimeType != other.runtimeType) {
      return false;
    }
    return id == (other as Source).id;
  }

  @override
  int get hashCode => id;

  @override
  Map<String, dynamic> toJson() => {
    'name'     : name,
    'mediatype': mediaType,
  };

  @override
  factory Source.from(Map<String, dynamic> json) => Source(
    id       : json['id'],
    name     : json['name'],
    mediaType: json['mediatype'],
  );
}