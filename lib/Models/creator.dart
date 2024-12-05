class Creator {
  // Data
  int id;
  String name;

  Creator({this.id = -1, required this.name});

  @override
  bool operator ==(Object other) {
    if (runtimeType != other.runtimeType) {
      return false;
    }
    return id == (other as Creator).id;
  }

  @override
  int get hashCode => id;

  Map<String, dynamic> toSupa() {
    return {
      "name": name,
    };
  }

  factory Creator.from(Map<String, dynamic> json) {
    return Creator(
      id: json["id"],
      name: json["name"],
    );
  }
}