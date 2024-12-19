import 'model.dart';

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
  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }

  @override
  factory Platform.from(Map<String, dynamic> json) {
    return Platform(
      id: json['id'],
      name: json['name'],
    );
  }

  // TODO: Endpoint this
  // static Future<Platform?> tryGet(String name) async {
  //   var list = await Supabase.instance.client.from('platform').select().eq('name', name);

  //   if (list.isEmpty) {
  //     return null;
  //   }

  //   return Platform.from(list.first);
  // }
}