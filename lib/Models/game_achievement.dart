import 'model.dart';

class GameAchievement implements Model {
  // Data
  int id;
  int gameId;
  String name;
  String description;

  GameAchievement({
    this.id = -1,
    required this.gameId,
    required this.name,
    required this.description
  });

  static String get endpoint => 'gameachievements';

  @override
  bool operator ==(Object other) {
    if (runtimeType != other.runtimeType) {
      return false;
    }
    return id == (other as GameAchievement).id;
  }

  @override
  int get hashCode => id;

  @override
  Map<String, dynamic> toJson() {
    return {
      'gameid': gameId,
      'name': name,
      'description': description,
    };
  }

  @override
  factory GameAchievement.from(Map<String, dynamic> json) {
    return GameAchievement(
      id: json['id'],
      gameId: json['gameid'],
      name: json['name'],
      description: json['description'],
    );
  }
}