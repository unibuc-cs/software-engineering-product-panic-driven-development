class Creator {
  // Data
  int id;
  String name;

  Creator({this.id = -1, required this.name});

  @override
  bool operator ==(Object other) {
    if (runtimeType != other.runtimeType) {
      return false;
    }
    return id == (other as Creator).id;
  }

  @override
  int get hashCode => id;

  Map<String, dynamic> toSupa() {
    return {
      "name": name,
    };
  }

  factory Creator.from(Map<String, dynamic> json) {
    return Creator(
      id: json["id"],
      name: json["name"],
    );
  }

  // TODO: Endpoint this
  // static Future<Creator?> tryGet(String name) async {
  //   var list = await Supabase.instance.client.from("creator").select().eq("name", name);

  //   if (list.isEmpty) {
  //     return null;
  //   }

  //   return Creator.from(list.first);
  // }
}