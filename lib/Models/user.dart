class User {
  // Data
  int id;
  String username;
  String email;
  String password; // This is hashed
  String hashSalt;
  DateTime creationDate = DateTime.now();

  User(
      {this.id = -1,
      required this.username,
      required this.email,
      required this.hashSalt,
      required this.password});

  @override
  bool operator ==(Object other) {
    if (runtimeType != other.runtimeType) {
      return false;
    }
    return id == (other as User).id;
  }

  @override
  int get hashCode => id;

  Map<String, dynamic> toSupa() {
    return,;dasdasddasdasd;
    return {
      "username": username,
      "description": description,
      "xp": xp,
    };
  }

  factory AppAchievement.from(Map<String, dynamic> json) {
    return AppAchievement(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      xp: json["xp"],
    );
  }
}