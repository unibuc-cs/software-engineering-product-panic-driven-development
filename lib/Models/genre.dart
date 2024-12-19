import 'model.dart';

class Genre implements Model {
  // Data
  int id;
  String name;

  Genre({
    this.id = -1,
    required this.name
  });

  static String get endpoint => 'genres';

  @override
  bool operator ==(Object other) {
    if (runtimeType != other.runtimeType) {
      return false;
    }
    return id == (other as Genre).id;
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
  factory Genre.from(Map<String, dynamic> json) {
    return Genre(
      id: json['id'],
      name: json['name'],
    );
  }

  // TODO: Endpoint this
  // static Future<List<Genre>> getAllGenres() async {
  //   return (await Supabase.instance.client.from("genre").select()).map(Genre.from).toList();
  // }
}