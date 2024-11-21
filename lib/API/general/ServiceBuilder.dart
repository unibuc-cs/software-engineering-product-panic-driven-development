import 'Service.dart';
import '../books/GoodReads.dart';
import '../games/HowLongToBeat.dart';
import '../games/IGDB.dart';
import '../games/PcGamingWiki.dart';
import '../streaming/Anilist.dart';
import '../streaming/Tmdb.dart';

class ServiceBuilder {
  static final _services = {
    "igdb": IGDB.instance,
    "pcgamingwiki": PcGamingWiki.instance,
    "howlongtobeat": HowLongToBeat.instance,
    "goodreads": GoodReads.instance,
    "tmdbmovies": Tmdb(mediaType: "movie"),
    "tmdbseries": Tmdb(mediaType: "tv"),
    "anilistanime": Anilist(mediaType: "ANIME"),
    "anilistmanga": Anilist(mediaType: "MANGA")
  };

  static Service? getService(String name) => _services[name.toLowerCase()];
}
