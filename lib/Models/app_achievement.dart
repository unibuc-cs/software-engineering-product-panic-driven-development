import 'model.dart';

class AppAchievement implements Model {
  // Data
  int id;
  String name;
  String description;
  int xp;

  AppAchievement({
    this.id = -1,
    required this.name,
    required this.description,
    this.xp = 100
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
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'xp': xp,
    };
  }

  @override
  factory AppAchievement.from(Map<String, dynamic> json) {
    return AppAchievement(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      xp: json['xp'],
    );
  }
}