import 'model.dart';

class MediaUser implements Model {
  // Data
  int mediaId;
  int userId;
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

  MediaUser({
    required this.mediaId,
    required this.userId,
    required this.name,
    required this.userScore,
    required this.addedDate,
    required this.coverImage,
    required this.status,
    required this.series,
    required this.icon,
    required this.backgroundImage,
    required this.lastInteracted,
    this.gameTime = 0,
    this.bookReadPages = 0,
    this.nrEpisodesSeen = 0
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
  Map<String, dynamic> toJson() {
    return {
      'mediaid': mediaId,
      'userid': userId,
      'name': name,
      'userscore': userScore,
      'addeddate': addedDate,
      'coverimage': coverImage,
      'status': status,
      'series': series,
      'icon': icon,
      'backgroundimage': backgroundImage,
      'lastinteracted': lastInteracted,
      'gametime': gameTime,
      'bookreadpages': bookReadPages,
      'nrepisodesseen': nrEpisodesSeen,
    };
  }

  @override
  factory MediaUser.from(Map<String, dynamic> json) {
    return MediaUser(
      mediaId: json['mediaid'],
      userId: json['userid'],
      name: json['name'],
      userScore: json['userscore'],
      addedDate: json['addeddate'],
      coverImage: json['coverimage'],
      status: json['status'],
      series: json['series'],
      icon: json['icon'],
      backgroundImage: json['backgroundimage'],
      lastInteracted: json['lastinteracted'],
      gameTime: json['gametime'],
      bookReadPages: json['bookreadpages'],
      nrEpisodesSeen: json['nrepisodesseen'],
    );
  }

  // TODO: Endpoint this
  // static Future<List<Media>> getUserMedia(int userId, String mediaType) async {
  //   List<Media> ans = List.empty();
  //   var ids = await Supabase.instance.client.from('mediauser').select('mediaid').eq('userid', userId);
  //   for(var json in await Supabase.instance.client.from('media').select().inFilter('mediaid', ids).eq('mediatype', mediaType)) {
  //     ans.add(Media.from(json));
  //   }
  //   return ans;
  // }
}