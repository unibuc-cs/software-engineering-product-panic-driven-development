class Tag {
  // Data
  int id;
  String name;

  Tag({this.id = -1, required this.name});

  @override
  bool operator ==(Object other) {
    if (runtimeType != other.runtimeType) {
      return false;
    }
    return id == (other as Tag).id;
  }

  @override
  int get hashCode => id;

  Map<String, dynamic> toSupa() {
    return {
      "name": name,
    };
  }

  factory Tag.from(Map<String, dynamic> json) {
    return Tag(
      id: json["id"],
      name: json["name"],
    );
  }
}