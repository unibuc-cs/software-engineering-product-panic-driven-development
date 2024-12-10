class Publisher {
  // Data
  int id;
  String name;

  Publisher({this.id = -1, required this.name});

  @override
  bool operator ==(Object other) {
    if (runtimeType != other.runtimeType) {
      return false;
    }
    return id == (other as Publisher).id;
  }

  @override
  int get hashCode => id;

  Map<String, dynamic> toSupa() {
    return {
      "name": name,
    };
  }

  factory Publisher.from(Map<String, dynamic> json) {
    return Publisher(
      id: json["id"],
      name: json["name"],
    );
  }
}