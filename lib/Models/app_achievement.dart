import 'general/model.dart';

class AppAchievement implements Model {
  // Data
  int id;
  String name;
  String description;
  int xp;

  AppAchievement({
    required this.name,
    required this.description,
    this.id = -1,
    this.xp = 100,
  });

  static String get endpoint => 'appachievements';

  @override
  bool operator ==(Object other) {
    if (runtimeType != other.runtimeType) {
      return false;
    }
    return id == (other as AppAchievement).id;
  }

  @override
  int get hashCode => id;

  @override
  Map<String, dynamic> toJson() => {
    'name'       : name,
    'description': description,
    'xp'         : xp,
  };

  @override
  factory AppAchievement.from(Map<String, dynamic> json) => AppAchievement(
    id         : json['id'],
    name       : json['name'],
    description: json['description'],
    xp         : json['xp'],
  );
}
