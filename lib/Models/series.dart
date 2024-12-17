class Series {
  // Data
  int id;
  String name;
  String index;

  Series({this.id = -1, required this.name, required this.index});

  @override
  bool operator ==(Object other) {
    if (runtimeType != other.runtimeType) {
      return false;
    }
    return id == (other as Series).id;
  }

  @override
  int get hashCode => id;

  Map<String, dynamic> toSupa() {
    return {
      "name": name,
      "index": index,
    };
  }

  factory Series.from(Map<String, dynamic> json) {
    return Series(
      id: json["id"],
      name: json["name"],
      index: json["index"],
    );
  }
}