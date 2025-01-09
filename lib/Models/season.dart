import 'general/model.dart';

class Season implements Model {
  // Data
  int TVSeriesId;
  int id;
  String name;
  int nrEpisodes;

  Season({
    this.id = -1,
    required this.TVSeriesId,
    required this.name,
    this.nrEpisodes = 0,
  });

  static String get endpoint => 'seasons';

  @override
  bool operator ==(Object other) {
    if (runtimeType != other.runtimeType) {
      return false;
    }
    return id == (other as Season).id;
  }

  int getTVSeriesId() {
    return TVSeriesId;
  }

  @override
  int get hashCode => id;

  @override
  Map<String, dynamic> toJson() {
    return {
      'tvseriesid': TVSeriesId,
      'name': name,
      'nrepisodes': nrEpisodes,
    };
  }

  @override
  factory Season.from(Map<String, dynamic> json) {
    return Season(
      id: json['id'],
      TVSeriesId: json['tvseriesid'],
      name: json['name'],
      nrEpisodes: json['nrepisodes'] ?? 0,
    );
  }
}