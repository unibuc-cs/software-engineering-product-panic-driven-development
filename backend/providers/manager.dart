import 'provider.dart';
import 'games/igdb.dart';
import 'streaming/tmdb.dart';
import 'books/goodreads.dart';
import 'streaming/anilist.dart';
import 'games/pcgamingwiki.dart';
import 'games/howlongtobeat.dart';

class Manager {
  final Provider provider;

  static final _providers = {
    "igdb": IGDB.instance,
    "pcgamingwiki": PcGamingWiki.instance,
    "howlongtobeat": HowLongToBeat.instance,
    "goodreads": GoodReads.instance,
    "tmdbmovie": Tmdb(mediaType: "movie"),
    "tmdbseries": Tmdb(mediaType: "tv"),
    "anilistanime": Anilist(mediaType: "ANIME"),
    "anilistmanga": Anilist(mediaType: "MANGA"),
  };

  Manager(String name) :
      provider = _providers[name.toLowerCase()] ??
                (throw ArgumentError("Service '$name' not found."));

  Provider? getProvider() => provider;

  Future<List<Map<String, dynamic>>> getOptions(String query) async {
    return await provider.getOptions(query) ?? [];
  }

  Future<Map<String, dynamic>> getInfo(String item) async {
    return await provider.getInfo(item) ?? {};
  }

  Future<List<Map<String, dynamic>>> getRecommendations(String item) async {
    return await provider.getRecommendations(item) ?? [];
  }
}
