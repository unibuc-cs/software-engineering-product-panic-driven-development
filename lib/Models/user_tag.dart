import 'general/model.dart';

class UserTag implements Model {
  // Data
  int id;
  String userId;
  String name;
  String mediaType;

  UserTag({
    this.id = -1,
    required this.userId,
    required this.name,
    required this.mediaType,
  });

  static String get endpoint => 'usertags';

  @override
  bool operator ==(Object other) {
    if (runtimeType != other.runtimeType) {
      return false;
    }
    return id == (other as UserTag).id;
  }

  @override
  int get hashCode => id;

  @override
  Map<String, dynamic> toJson() => {
    'userid'   : userId,
    'name'     : name,
    'mediatype': mediaType,
  };

  @override
  factory UserTag.from(Map<String, dynamic> json) => UserTag(
    id       : json['id'],
    userId   : json['userid'],
    name     : json['name'],
    mediaType: json['mediatype'],
  );
}
