class User {
  // Data
  int id;
  int idAuth;

  User(
      {this.id = -1,
      this.idAuth = -1});

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
    return {
      "idauth": idAuth,
    };
  }

  factory User.from(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      idAuth: json["idauth"],
    );
  }
}