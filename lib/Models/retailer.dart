import 'general/model.dart';

class Retailer implements Model {
  // Data
  int id;
  String name;

  Retailer({
    this.id = -1,
    required this.name
  });

  static String get endpoint => 'retailers';

  @override
  bool operator ==(Object other) {
    if (runtimeType != other.runtimeType) {
      return false;
    }
    return id == (other as Retailer).id;
  }

  @override
  int get hashCode => id;

  @override
  Map<String, dynamic> toJson() => {
    'name': name,
  };

  @override
  factory Retailer.from(Map<String, dynamic> json) => Retailer(
    id  : json['id'],
    name: json['name'],
  );
}
