class Season {
  // Data
  int TVSeriesId;
  int id;
  String name;
  String coverImage;

  Season({
    this.id = -1,
    required this.TVSeriesId,
    required this.name,
    required this.coverImage,
  });

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

  Map<String, dynamic> toSupa() {
    return {
      "tvseriesid": TVSeriesId,
      "name": name,
      "coverimage": coverImage,
    };
  }

  factory Season.from(Map<String, dynamic> json) {
    return Season(
      id: json["id"],
      TVSeriesId: json["tvseriesid"],
      name: json["name"],
      coverImage: json["coverimage"],
    );
  }
}