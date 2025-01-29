import 'general/model.dart';

class Wishlist implements Model {
  // Data
  int mediaId;
  String userId;
  String name;
  int userScore;
  DateTime addedDate;
  String coverImage;
  String series;
  String icon;
  String backgroundImage;
  DateTime lastInteracted;

  Wishlist({
    required this.mediaId,
    required this.userId,
    required this.name,
    required this.addedDate,
    required this.lastInteracted,
    this.userScore       = 0,
    this.coverImage      = '',
    this.series          = '',
    this.icon            = '',
    this.backgroundImage = '',
  });

  static String get endpoint => 'wishlists';

  @override
  bool operator ==(Object other) {
    if (runtimeType != other.runtimeType) {
      return false;
    }
    return mediaId == (other as Wishlist).mediaId && userId == other.userId;
  }

  @override
  int get hashCode => Object.hash(mediaId, userId);

  @override
  dynamic get id => mediaId;

  @override
  Map<String, dynamic> toJson() => {
    'mediaid'        : mediaId,
    'userid'         : userId,
    'name'           : name,
    'userscore'      : userScore,
    'addeddate'      : addedDate.toIso8601String(),
    'coverimage'     : coverImage,
    'series'         : series,
    'icon'           : icon,
    'backgroundimage': backgroundImage,
    'lastinteracted' : lastInteracted.toIso8601String(),
  };

  @override
  factory Wishlist.from(Map<String, dynamic> json) => Wishlist(
    mediaId        : json['mediaid'],
    userId         : json['userid'],
    name           : json['name'],
    userScore      : json['userscore'] ?? 0,
    addedDate      : DateTime.parse(json['addeddate']),
    coverImage     : json['coverimage'] ?? '',
    series         : json['series'] ?? '',
    icon           : json['icon'] ?? '',
    backgroundImage: json['backgroundimage'] ?? '',
    lastInteracted : DateTime.parse(json['lastinteracted']),
  );
}
