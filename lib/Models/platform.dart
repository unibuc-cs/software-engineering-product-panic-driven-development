import 'general/model.dart';

class Platform implements Model {
  // Data
  int id;
  String name;

  Platform({
    this.id = -1,
    required this.name
  });

  static String get endpoint => 'platforms';

  @override
  bool operator ==(Object other) {
    if (runtimeType != other.runtimeType) {
      return false;
    }
    return id == (other as Platform).id;
  }

  @override
  int get hashCode => id;

  @override
  Map<String, dynamic> toJson() => {
    'name': name,
  };

  @override
  factory Platform.from(Map<String, dynamic> json) => Platform(
    id  : json['id'],
    name: json['name'],
  );
}
