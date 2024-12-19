import 'model.dart';

class MediaUserTag implements Model {
  // Data
  int mediaId;
  int userId;
  int tagId;

  MediaUserTag(
      {required this.mediaId, required this.userId, required this.tagId});

  @override
  bool operator ==(Object other) {
    if (runtimeType != other.runtimeType) {
      return false;
    }
    return userId == (other as MediaUserTag).userId &&
        mediaId == other.mediaId &&
        tagId == other.tagId;
  }

  @override
  int get hashCode => Object.hash(mediaId, userId, tagId);

  @override
  Map<String, dynamic> toJson() {
    return {
      'mediaid': mediaId,
      'userid': userId,
      'tagid': tagId,
    };
  }

  @override
  factory MediaUserTag.from(Map<String, dynamic> json) {
    return MediaUserTag(
      mediaId: json['mediaid'],
      userId: json['userid'],
      tagId: json['tagid'],
    );
  }

  // TODO: Endpoint this
  // Returns a set of genre ids such that there exists a MediaUserGenre in the database that has these 3 properties
  // static Future<Set<int>> getAllFor(int mediaId, int userId) async {
  //   return (await Supabase.instance.client.from('mediausergenre').select('genreid').eq('mediaid', mediaId).eq('userid', userId)).map((x) => x['genreid'] as int).toSet();
  // }
}