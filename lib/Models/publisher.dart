import 'general/model.dart';

class Publisher implements Model {
  // Data
  int id;
  String name;

  Publisher({
    this.id = -1,
    required this.name
  });

  static String get endpoint => 'publishers';

  @override
  bool operator ==(Object other) {
    if (runtimeType != other.runtimeType) {
      return false;
    }
    return id == (other as Publisher).id;
  }

  @override
  int get hashCode => id;

  @override
  Map<String, dynamic> toJson() => {
    'name': name,
  };

  @override
  factory Publisher.from(Map<String, dynamic> json) => Publisher(
    id  : json['id'],
    name: json['name'],
  );
}
