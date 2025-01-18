import 'general/model.dart';

class Tag implements Model {
  // Data
  int id;
  String name;

  Tag({
    this.id = -1,
    required this.name
  });

  static String get endpoint => 'tags';

  @override
  bool operator ==(Object other) {
    if (runtimeType != other.runtimeType) {
      return false;
    }
    return id == (other as Tag).id;
  }

  @override
  int get hashCode => id;

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }

  @override
  factory Tag.from(Map<String, dynamic> json) {
    return Tag(
      id: json['id'],
      name: json['name'],
    );
  }
}