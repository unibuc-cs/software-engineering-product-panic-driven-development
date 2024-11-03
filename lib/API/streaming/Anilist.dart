import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../general/Service.dart';

class Anilist extends Service {
  // Members
  final _headers = {
    "Content-Type": "application/json"
  };
  final _url = Uri.parse("https://graphql.anilist.co/");
  final badItems = [{"<br><br>": " ", "<br>": " "}, "<i>", "</i>", "\n", "\r"];
  String _mediaType = "";
  
  // Private constructor
  Anilist._();

  // Singleton instance
  static final Anilist _instance = Anilist._();

  // Accessor for the singleton instance
  static Anilist get instance => _instance;

  // Private methods
  String _removeBadItems(String input) {
    for (var item in badItems) {
      if (item is String) {
        input = input.replaceAll(item, "");
      } 
      else if (item is Map<String, String>) {
        item.forEach((key, value) {
          input = input.replaceAll(key, value);
        });
      }
    }
    return input;
  }

  Future<List<Map<String, dynamic>>> _getMediaOptions(String name) async {
    final query = '''
      query {
        Page {
          media(search: "$name", type: $_mediaType) {
            id
            title {
              romaji
              english
            }
          }
        }
      }
    ''';

    try {
      final response = await http.post(
        _url,
        headers: _headers,
        body: json.encode({"query": query}),
      );

      if (response.statusCode != 200) {
        return [];
      }

      return (json.decode(response.body)["data"]["Page"]["media"] as List).map((media) {
        // Prefer the English title, fallback to the Japanese one
        return {
          "id": media["id"],
          "name": _removeBadItems(media["title"]["english"] ?? media["title"]["romaji"])
        };
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Map<String, dynamic> _sharedInfo(Map<String, dynamic> media) {
    String formatTwoDigits(int value) {
      return value.toString().padLeft(2, '0');
    }

    return {
      "id": media["id"],
      "title": {
        "romaji": media["title"]["romaji"],
        "english": media["title"]["english"]
      },
      "description": _removeBadItems(media["description"]),
      "release_date": DateTime.parse(
        '${media["startDate"]["year"]}-'
        '${formatTwoDigits(media["startDate"]["month"])}-'
        '${formatTwoDigits(media["startDate"]["day"])}'
      ),
      "genres": media["genres"]
    };
  }

  Future<Map<String, dynamic>> _getAnimeInfo(String animeId) async {
    try {
      final query = '''
        query {
          Media(id: $animeId) {
            id
            title {
              romaji
              english
              native
            }
            description
            startDate {
              year
              month
              day
            }
            genres
            episodes
          }
        }
      ''';
      final response = await http.post(
        _url,
        headers: _headers,
        body: json.encode({"query": query}),
      );

      if (response.statusCode != 200) {
        return {};
      }

      final anime = json.decode(response.body)['data']['Media'];
      return {
        ..._sharedInfo(anime),
        "episodes": anime["episodes"]
      };
    } catch (e) {
      return {};
    }
  }

  Future<Map<String, dynamic>> _getMangaInfo(String mangaId) async {
    try {
      final query = '''
        query {
          Media(id: $mangaId) {
            id
            title {
              romaji
              english
              native
            }
            description
            startDate {
              year
              month
              day
            }
            genres
            chapters
          }
        }
      ''';
      final response = await http.post(
        _url,
        headers: _headers,
        body: json.encode({"query": query}),
      );

      if (response.statusCode != 200) {
        return {};
      }

      final manga = json.decode(response.body)['data']['Media'];
      return {
        ..._sharedInfo(manga),
        "chapters": manga["chapters"]
      };
    } catch (e) {
      return {};
    }
  }

  // Public methods
  void setAnime() {
    _mediaType = "ANIME";
  }

  void setManga() {
    _mediaType = "MANGA";
  }

  @override
  Future<List<Map<String, dynamic>>> getOptions(String name) async {
    return instance._getMediaOptions(name);
  }

  @override
  Future<Map<String, dynamic>> getInfo(String id) async {
    if (_mediaType == 'ANIME') {
      return instance._getAnimeInfo(id);
    } else {
      return instance._getMangaInfo(id);
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getRecommendations(int id) async {
    return [];
  }
}
