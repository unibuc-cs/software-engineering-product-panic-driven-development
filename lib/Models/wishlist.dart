import "media.dart";
import "package:supabase_flutter/supabase_flutter.dart";

class Wishlist {
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

  Wishlist(
      {required this.mediaId,
      required this.userId,
      required this.name,
      required this.userScore,
      required this.addedDate,
      required this.coverImage,
      required this.status,
      required this.series,
      required this.icon,
      required this.backgroundImage,
      required this.lastInteracted});

  @override
  bool operator ==(Object other) {
    if (runtimeType != other.runtimeType) {
      return false;
    }
    return mediaId == (other as Wishlist).mediaId && userId == other.userId;
  }

  @override
  int get hashCode => Object.hash(mediaId, userId);

  Map<String, dynamic> toSupa() {
    return {
      "mediaid": mediaId,
      "userid": userId,
      "name": name,
      "userscore": userScore,
      "addeddate": addedDate,
      "coverimage": coverImage,
      "status": status,
      "series": series,
      "icon": icon,
      "backgroundimage": backgroundImage,
      "lastinteracted": lastInteracted,
    };
  }

  factory Wishlist.from(Map<String, dynamic> json) {
    return Wishlist(
      mediaId: json["mediaid"],
      userId: json["userid"],
      name: json["name"],
      userScore: json["userscore"],
      addedDate: json["addeddate"],
      coverImage: json["coverimage"],
      status: json["status"],
      series: json["series"],
      icon: json["icon"],
      backgroundImage: json["backgroundimage"],
      lastInteracted: json["lastinteracted"],
    );
  }

  Future<Media> get media async {
    return Media
      .from(
        await Supabase
          .instance
          .client
          .from("media")
          .select()
          .eq("mediaid", mediaId)
          .single()
      );
  }
}