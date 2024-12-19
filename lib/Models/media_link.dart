import 'model.dart';

class MediaLink implements Model {
  // Data
  int mediaId;
  int linkId;

  MediaLink({required this.mediaId, required this.linkId});

  @override
  bool operator ==(Object other) {
    if (runtimeType != other.runtimeType) {
      return false;
    }
    return mediaId == (other as MediaLink).mediaId && linkId == other.linkId;
  }

  @override
  int get hashCode => Object.hash(mediaId, linkId);

  @override
  Map<String, dynamic> toJson() {
    return {
      'mediaid': mediaId,
      'linkid': linkId,
    };
  }

  @override
  factory MediaLink.from(Map<String, dynamic> json) {
    return MediaLink(
      mediaId: json['mediaid'],
      linkId: json['linkid'],
    );
  }

  // TODO: Endpoint this
  // static Future<List<Link>> getLinks(int mediaId) async {
  //   List<dynamic> ids = await Supabase
  //     .instance
  //     .client
  //     .from('medialink')
  //     .select('linkid')
  //     .eq('mediaid', mediaId);

  //   List<Link> ans = List.empty(
  //     growable: true,
  //   );

  //   for(var json in await Supabase.instance.client.from('link').select().inFilter('id', ids)) {
  //     ans.add(Link.from(json));
  //   }

  //   return ans;
  // }
}