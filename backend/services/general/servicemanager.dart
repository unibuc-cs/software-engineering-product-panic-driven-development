import 'service.dart';
import '../games/igdb.dart';
import '../streaming/tmdb.dart';
import '../books/goodreads.dart';
import '../streaming/anilist.dart';
import '../games/pcgamingwiki.dart';
import '../games/howlongtobeat.dart';

class ServiceManager {
  final Service service;

  static final _services = {
    "igdb": IGDB.instance,
    "pcgamingwiki": PcGamingWiki.instance,
    "howlongtobeat": HowLongToBeat.instance,
    "goodreads": GoodReads.instance,
    "tmdbmovies": Tmdb(mediaType: "movie"),
    "tmdbseries": Tmdb(mediaType: "tv"),
    "anilistanime": Anilist(mediaType: "ANIME"),
    "anilistmanga": Anilist(mediaType: "MANGA"),
  };

  ServiceManager(String name) :
      service = _services[name.toLowerCase()] ??
                (throw ArgumentError("Service '$name' not found."));

  Service? getService() => service;

  Future<List<Map<String, dynamic>>> getOptions(String query) async {
    return await service.getOptions(query) ?? [];
  }

  Future<Map<String, dynamic>> getInfo(String item) async {
    return await service.getInfo(item) ?? {};
  }

  Future<List<Map<String, dynamic>>> getRecommendations(String item) async {
    return await service.getRecommendations(item) ?? [];
  }
}
