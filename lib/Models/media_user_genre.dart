import 'model.dart';

class MediaUserGenre implements Model {
  // Data
  int mediaId;
  int userId;
  int genreId;

  MediaUserGenre(
      {required this.mediaId, required this.userId, required this.genreId});

  @override
  bool operator ==(Object other) {
    if (runtimeType != other.runtimeType) {
      return false;
    }
    return mediaId == (other as MediaUserGenre).mediaId &&
        userId == other.userId &&
        genreId == other.genreId;
  }

  @override
  int get hashCode => Object.hash(mediaId, userId, genreId);

  @override
  Map<String, dynamic> toJson() {
    return {
      'mediaid': mediaId,
      'userid': userId,
      'genreid': genreId,
    };
  }

  @override
  factory MediaUserGenre.from(Map<String, dynamic> json) {
    return MediaUserGenre(
      mediaId: json['mediaid'],
      userId: json['userid'],
      genreId: json['genreid'],
    );
  }

  // TODO: Endpoint this
  // Returns a set of tag ids such that there exists a MediaUserTag in the database that has these 3 properties
  // static Future<Set<int>> getAllFor(int mediaId, int userId) async {
  //   return (await Supabase.instance.client.from('mediausertag').select('tagid').eq('mediaid', mediaId).eq('userid', userId)).map((x) => x['tagid'] as int).toSet();
  // }
}