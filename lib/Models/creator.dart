import 'general/model.dart';

class Creator implements Model {
  // Data
  int id;
  String name;

  Creator({
    this.id = -1,
    required this.name
  });

  static String get endpoint => 'creators';

  @override
  bool operator ==(Object other) {
    if (runtimeType != other.runtimeType) {
      return false;
    }
    return id == (other as Creator).id;
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
  factory Creator.from(Map<String, dynamic> json) {
    return Creator(
      id: json['id'],
      name: json['name'],
    );
  }
}