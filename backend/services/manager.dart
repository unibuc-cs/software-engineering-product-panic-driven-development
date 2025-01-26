import 'provider.dart';
import 'games/igdb.dart';
import 'games/steam.dart';
import 'streaming/tmdb.dart';
import 'books/goodreads.dart';
import 'streaming/trakt.dart';
import 'streaming/anilist.dart';
import 'games/pcgamingwiki.dart';
import 'books/goodreadslist.dart';
import 'games/howlongtobeat.dart';
import 'streaming/myanimelist.dart';

class Manager {
  late Provider provider;

  static final _providers = {
    'steam'        : Steam.instance,
    'goodreads'    : GoodReads.instance,
    'goodreadslist': GoodReadsList.instance,
    'pcgamingwiki' : PcGamingWiki.instance,
    'howlongtobeat': HowLongToBeat.instance,
    'tmdbseries'   : Tmdb(mediaType: 'tv'),
    'tmdbmovie'    : Tmdb(mediaType: 'movie'),
    'traktmovies'  : Trakt(mediaType: 'movies'),
    'traktseries'  : Trakt(mediaType: 'shows'),
    'anilistanime' : Anilist(mediaType: 'ANIME'),
    'anilistmanga' : Anilist(mediaType: 'MANGA'),
    'myanimelist'  : MyAnimeList(mediaType: 'anime'),
    'mymangalist'  : MyAnimeList(mediaType: 'manga'),
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
