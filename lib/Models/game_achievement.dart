class GameAchievement {
  // Data
  int id;
  int gameId;
  String name;
  String description;

  GameAchievement(
      {this.id = -1,
      required this.gameId,
      required this.name,
      required this.description});

  @override
  bool operator ==(Object other) {
    if (runtimeType != other.runtimeType) {
      return false;
    }
    return id == (other as GameAchievement).id;
  }

  @override
  int get hashCode => id;

  Map<String, dynamic> toSupa() {
    return {
      "gameid": gameId,
      "name": name,
      "description": description,
    };
  }

  factory GameAchievement.from(Map<String, dynamic> json) {
    return GameAchievement(
      id: json["id"],
      gameId: json["gameid"],
      name: json["name"],
      description: json["description"],
    );
  }
}