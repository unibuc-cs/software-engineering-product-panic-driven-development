class AppAchievement {
  // Data
  int id;
  String name;
  String description;
  int xp;

  AppAchievement(
      {this.id = -1,
      required this.name,
      required this.description,
      this.xp = 100});

  @override
  bool operator ==(Object other) {
    if (runtimeType != other.runtimeType) {
      return false;
    }
    return id == (other as AppAchievement).id;
  }

  @override
  int get hashCode => id;

  Map<String, dynamic> toSupa() {
    return {
      "name": name,
      "description": description,
      "xp": xp,
    };
  }

  factory AppAchievement.from(Map<String, dynamic> json) {
    return AppAchievement(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      xp: json["xp"],
    );
  }
}