import 'general/model.dart';

class Wishlist implements Model {
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

  Wishlist({
    required this.mediaId,
    required this.userId,
    required this.name,
    this.userScore = 0,
    required this.addedDate,
    this.coverImage = '',
    this.status = '',
    this.series = '',
    this.icon = '',
    this.backgroundImage = '',
    required this.lastInteracted
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
  Map<String, dynamic> toJson() {
    return {
      'mediaid': mediaId,
      'userid': userId,
      'name': name,
      'userscore': userScore,
      'addeddate': addedDate.toIso8601String(),
      'coverimage': coverImage,
      'status': status,
      'series': series,
      'icon': icon,
      'backgroundimage': backgroundImage,
      'lastinteracted': lastInteracted.toIso8601String(),
    };
  }

  @override
  factory Wishlist.from(Map<String, dynamic> json) {
    return Wishlist(
      mediaId: json['mediaid'],
      userId: json['userid'],
      name: json['name'],
      userScore: json['userscore'] ?? 0,
      addedDate: DateTime.parse(json['addeddate']),
      coverImage: json['coverimage'] ?? '',
      status: json['status'] ?? '',
      series: json['series'] ?? '',
      icon: json['icon'] ?? '',
      backgroundImage: json['backgroundimage'] ?? '',
      lastInteracted: DateTime.parse(json['lastinteracted']),
    );
  }

  // TODO: Endpoint this
  // Future<Media> get media async {
  //   return Media
  //     .from(
  //       await Supabase
  //         .instance
  //         .client
  //         .from('media')
  //         .select()
  //         .eq('mediaid', mediaId)
  //         .single()
  //     );
  // }
}