import 'general/model.dart';

class Media implements Model {
  // Data
  int id;
  String originalName;
  String description;
  DateTime releaseDate;
  int criticScore;
  int communityScore;
  String mediaType;

  Media({
    this.id = -1,
    required this.originalName,
    this.description = '',
    required this.releaseDate,
    this.criticScore = 0,
    this.communityScore = 0,
    required this.mediaType
  });

  static String get endpoint => 'medias';

  @override
  bool operator ==(Object other) {
    if (runtimeType != other.runtimeType) {
      return false;
    }
    return id == (other as Media).id;
  }

  @override
  int get hashCode => id;

  @override
  Map<String, dynamic> toJson() {
    return {
      'originalname': originalName,
      'description': description,
      'releasedate': releaseDate.toIso8601String(),
      'criticscore': criticScore,
      'communityscore': communityScore,
      'mediatype': mediaType,
    };
  }

  @override
  factory Media.from(Map<String, dynamic> json) {
    return Media(
      id: json['id'],
      originalName: json['originalname'],
      description: json['description'] ?? '',
      releaseDate: DateTime.parse(json['releasedate']),
      criticScore: json['criticscore'] ?? 0,
      communityScore: json['communityscore'] ?? 0,
      mediaType: json['mediatype'],
    );
  }

  // // TODO: Turn this into an endpoint
  // Future<List<Publisher>> get publishers async {
  //   final supabase = Supabase.instance.client;
  //   List<dynamic> publisherIds = await supabase
  //     .from('mediapublisher')
  //     .select('publisherid')
  //     .eq('mediaid', id);
  //   return (await supabase
  //     .from('publisher')
  //     .select()
  //     .inFilter('id', publisherIds))
  //     .map(Publisher.from)
  //     .toList();
  // }

  // // TODO: Turn this into an endpoint
  // Future<List<Creator>> get creators async {
  //   final supabase = Supabase.instance.client;
  //   List<dynamic> creatorsIds = await supabase
  //     .from('mediacreator')
  //     .select('creatorid')
  //     .eq('mediaid', id);
  //   return (await supabase
  //     .from('creator')
  //     .select()
  //     .inFilter('id', creatorsIds))
  //     .map(Creator.from)
  //     .toList();
  // }

  // // TODO: Turn this into an endpoint
  // Future<List<Platform>> get platforms async {
  //   final supabase = Supabase.instance.client;
  //   List<dynamic> platformsIds = await supabase
  //     .from('mediaplatform')
  //     .select('platformid')
  //     .eq('mediaid', id);
  //   return (await supabase
  //     .from('platform')
  //     .select()
  //     .inFilter('id', platformsIds))
  //     .map(Platform.from)
  //     .toList();
  // }
}