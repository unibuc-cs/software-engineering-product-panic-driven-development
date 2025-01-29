import 'general/model.dart';

class MediaUser implements Model {
  // Data
  int mediaId;
  String userId;
  String name;
  int userScore;
  DateTime addedDate;
  String coverImage;
  String status;
  String series;
  String icon;
  String backgroundImage;
  DateTime lastInteracted;
  int gameTime;
  int bookReadPages;
  int nrEpisodesSeen;
  int mangaReadChapters;
  int movieSecondsWatched;

  MediaUser({
    required this.mediaId,
    required this.userId,
    required this.name,
    required this.addedDate,
    required this.lastInteracted,
    this.userScore           = 0,
    this.coverImage          = '',
    this.status              = '',
    this.series              = '',
    this.icon                = '',
    this.backgroundImage     = '',
    this.gameTime            = 0,
    this.bookReadPages       = 0,
    this.nrEpisodesSeen      = 0,
    this.mangaReadChapters   = 0,
    this.movieSecondsWatched = 0,
  });

  static String get endpoint => 'mediausers';

  @override
  bool operator ==(Object other) {
    if (runtimeType != other.runtimeType) {
      return false;
    }
    return mediaId == (other as MediaUser).mediaId && userId == other.userId;
  }

  @override
  int get hashCode => Object.hash(mediaId, userId);

  @override
  dynamic get id => mediaId;

  @override
  Map<String, dynamic> toJson() => {
    'mediaid'            : mediaId,
    'userid'             : userId,
    'name'               : name,
    'userscore'          : userScore,
    'addeddate'          : addedDate.toIso8601String(),
    'coverimage'         : coverImage,
    'status'             : status,
    'series'             : series,
    'icon'               : icon,
    'backgroundimage'    : backgroundImage,
    'lastinteracted'     : lastInteracted.toIso8601String(),
    'gametime'           : gameTime,
    'bookreadpages'      : bookReadPages,
    'nrepisodesseen'     : nrEpisodesSeen,
    'mangareadchapters'  : mangaReadChapters,
    'moviesecondswatched': movieSecondsWatched,
  };

  @override
  factory MediaUser.from(Map<String, dynamic> json) => MediaUser(
    mediaId            : json['mediaid'],
    userId             : json['userid'],
    name               : json['name'],
    userScore          : json['userscore'] ?? 0,
    addedDate          : DateTime.parse(json['addeddate']),
    coverImage         : json['coverimage'] ?? '',
    status             : json['status'] ?? '',
    series             : json['series'] ?? '',
    icon               : json['icon'] ?? '',
    backgroundImage    : json['backgroundimage'] ?? '',
    lastInteracted     : DateTime.parse(json['lastinteracted']),
    gameTime           : json['gametime'] ?? 0,
    bookReadPages      : json['bookreadpages'] ?? 0,
    nrEpisodesSeen     : json['nrepisodesseen'] ?? 0,
    mangaReadChapters  : json['mangareadchapters'] ?? 0,
    movieSecondsWatched: json['moviesecondswatched'] ?? 0,
  );
}
