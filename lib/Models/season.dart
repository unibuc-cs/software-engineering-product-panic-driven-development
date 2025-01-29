import 'general/model.dart';

class Season implements Model {
  // Data
  int TVSeriesId;
  int id;
  String name;
  int nrEpisodes;

  Season({
    required this.TVSeriesId,
    required this.name,
    this.id         = -1,
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

  int getTVSeriesId() => TVSeriesId;

  @override
  int get hashCode => id;

  @override
  Map<String, dynamic> toJson() => {
    'tvseriesid': TVSeriesId,
    'name'      : name,
    'nrepisodes': nrEpisodes,
  };

  @override
  factory Season.from(Map<String, dynamic> json) => Season(
    id        : json['id'],
    TVSeriesId: json['tvseriesid'],
    name      : json['name'],
    nrEpisodes: json['nrepisodes'] ?? 0,
  );
}
