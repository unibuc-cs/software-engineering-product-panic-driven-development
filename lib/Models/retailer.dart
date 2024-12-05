class Retailer {
  // Data
  int id;
  String name;

  Retailer({this.id = -1, required this.name});

  @override
  bool operator ==(Object other) {
    if (runtimeType != other.runtimeType) {
      return false;
    }
    return id == (other as Retailer).id;
  }

  @override
  int get hashCode => id;

  Map<String, dynamic> toSupa() {
    return {
      "name": name,
    };
  }

  factory Retailer.from(Map<String, dynamic> json) {
    return Retailer(
      id: json["id"],
      name: json["name"],
    );
  }
}