import 'model.dart';

class Series implements Model {
  // Data
  int id;
  String name;

  Series({
    this.id = -1,
    required this.name
  });

  static String get endpoint => 'series';

  @override
  bool operator ==(Object other) {
    if (runtimeType != other.runtimeType) {
      return false;
    }
    return id == (other as Series).id;
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
  factory Series.from(Map<String, dynamic> json) {
    return Series(
      id: json['id'],
      name: json['name'],
    );
  }
}