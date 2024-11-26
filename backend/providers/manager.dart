import 'provider.dart';
import 'games/igdb.dart';
import 'games/steam.dart';
import 'streaming/tmdb.dart';
import 'books/goodreads.dart';
import 'streaming/anilist.dart';
import 'games/pcgamingwiki.dart';
import 'games/howlongtobeat.dart';

class Dummy extends Provider {
  @override
  Future<List<Map<String, dynamic>>> getOptions(String query) async {
    return [{"error": "No provider found"}];
  }

  @override
  Future<Map<String, dynamic>> getInfo(String item) async {
    return {"error": "No provider found"};
  }

  @override
  Future<List<Map<String, dynamic>>> getRecommendations(String item) async {
    return [{"error": "No provider found"}];
  }
}

class Manager {
  late Provider provider;

  static final _providers = {
    "pcgamingwiki": PcGamingWiki.instance,
    "howlongtobeat": HowLongToBeat.instance,
    "steam": Steam.instance,
    "goodreads": GoodReads.instance,
    "tmdbmovie": Tmdb(mediaType: "movie"),
    "tmdbseries": Tmdb(mediaType: "tv"),
    "anilistanime": Anilist(mediaType: "ANIME"),
    "anilistmanga": Anilist(mediaType: "MANGA"),
  };

  Manager(String name) {
    if (name.toLowerCase() == "igdb") {
      // we need a new IGDB instance every time, because it handles internal state
      provider = IGDB();
    }
    else {
      provider = _providers[name.toLowerCase()] ?? Dummy();
    }
  }

  Provider? getProvider() => provider;

  Future<List<Map<String, dynamic>>> getOptions(String query) async {
    return await provider.getOptions(query) ??
           [{"error": "Something went wrong" }];
  }

  Future<Map<String, dynamic>> getInfo(String item) async {
    return await provider.getInfo(item) ??
           {"error": "Something went wrong" };
  }

  Future<List<Map<String, dynamic>>> getRecommendations(String item) async {
    return await provider.getRecommendations(item) ??
           [{"error": "Something went wrong" }];
  }
}
