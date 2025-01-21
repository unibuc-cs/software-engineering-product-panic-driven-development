import 'provider.dart';
import 'games/igdb.dart';
import 'games/steam.dart';
import 'streaming/tmdb.dart';
import 'books/goodreads.dart';
import 'streaming/anilist.dart';
import 'games/pcgamingwiki.dart';
import 'games/howlongtobeat.dart';

class Manager {
  late Provider provider;

  static final _providers = {
    'pcgamingwiki' : PcGamingWiki.instance,
    'howlongtobeat': HowLongToBeat.instance,
    'steam'        : Steam.instance,
    'goodreads'    : GoodReads.instance,
    'tmdbmovie'    : Tmdb(mediaType: 'movie'),
    'tmdbseries'   : Tmdb(mediaType: 'tv'),
    'anilistanime' : Anilist(mediaType: 'ANIME'),
    'anilistmanga' : Anilist(mediaType: 'MANGA'),
  };

  Manager(String name) {
    provider = name.toLowerCase() == 'igdb'
      ? IGDB()
      : _providers[name.toLowerCase()]!;
  }

  Provider? getProvider() => provider;

  Future<List<Map<String, dynamic>>> getOptions(String query) async =>
    await provider.getOptions(query);

  Future<Map<String, dynamic>> getInfo(String item) async =>
    await provider.getInfo(item);

  Future<List<Map<String, dynamic>>> getRecommendations(String item) async =>
    await provider.getRecommendations(item);
}
