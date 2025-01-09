import 'model.dart';

class User implements Model {
  // Data
  int id;
  int idAuth;

  User({
    this.id = -1,
    this.idAuth = -1
  });

  static String get endpoint => 'users';

  @override
  bool operator ==(Object other) {
    if (runtimeType != other.runtimeType) {
      return false;
    }
    return id == (other as User).id;
  }

  @override
  int get hashCode => id;

  @override
  Map<String, dynamic> toJson() {
    return {
      'idauth': idAuth,
    };
  }

  @override
  factory User.from(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      idAuth: json['idauth'],
    );
  }
}