class Series {
  // Data
  int id;
  String name;

  Series({this.id = -1, required this.name});

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
    };
  }

  factory Series.from(Map<String, dynamic> json) {
    return Series(
      id: json["id"],
      name: json["name"],
    );
  }
}