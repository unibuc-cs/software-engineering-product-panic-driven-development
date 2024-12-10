import 'game.dart';

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

  Game get game {
    if (_game == null) {
      Box<Game> box = Hive.box<Game>('games');
      for (int i = 0; i < box.length; ++i) {
        if (gameId == box.getAt(i)!.id) {
          _game = box.getAt(i);
        }
      }
      if (_game == null) {
        throw Exception(
            "Game Achievement of id $id does not have an associated Game object or gameId value is wrong ($gameId)");
      }
    }
    return _game!;
  }
}