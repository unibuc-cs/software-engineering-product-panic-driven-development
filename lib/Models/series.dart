class Series {
  // Data
  int id;
  String index;

  Series({this.id = -1, required this.index});

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
      "index": index,
    };
  }

  factory Series.from(Map<String, dynamic> json) {
    return Series(
      id: json["id"],
      index: json["index"],
    );
  }
}