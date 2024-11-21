import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../general/Service.dart';

class Anilist extends Service {
  // Members
  final _headers = {
    "Content-Type": "application/json"
  };
  final _replaceItems = {
    "<br><br>": " ",
    "<br>": " "
  };
  final _removeItems = [
    "<i>",
    "</i>",
    "\n",
    "\r"
  ];
  final _url = Uri.parse("https://graphql.anilist.co/");
  String _mediaType = "";

  // Public constructor
  Anilist({required String mediaType}) : _mediaType = mediaType;

  // Private methods
  String _removeBadItems(String input) {
    _removeItems.forEach((item) {
      input = input.replaceAll(item, "");
    });
    _replaceItems.forEach((key, value) {
      input = input.replaceAll(key, value);
    });
    return input;
  }

  Future<Map<String, dynamic>> _getResponse(String query) async {
    try {
      final response = await http.post(
        _url,
        headers: _headers,
        body: json.encode({"query": query}),
      );

      if (response.statusCode != 200) {
        return {};
      }

      return json.decode(response.body)["data"];

    } catch (e) {
      return {};
    }
  }

  Future<List<Map<String, dynamic>>> _getMediaOptions(String name) async {
    try {
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
      final response = await _getResponse(query);

      if (response.isEmpty) {
        return [];
      }

      return (response["Page"]["media"] as List).map((media) {
        return {
          "id": media["id"],
          // Prefer the English title, fallback to the Japanese one
          "name": _removeBadItems(media["title"]["english"] ?? media["title"]["romaji"])
        };
      }).toList();

    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>> _getMediaById(String id, List<String> customFields) async {
    try {
      final query = '''
        query {
          Media(id: $id) {
            id
            title {
              romaji
              english
            }
            description
            startDate {
              year
              month
              day
            }
            genres
            ${customFields.join("\n")}
          }
        }
      ''';
      final response = await _getResponse(query);

      if (response.isEmpty) {
        return {};
      }

      return response["Media"];

    } catch (e) {
      return {};
    }
  }

  Map<String, dynamic> _sharedInfo(Map<String, dynamic> media) {
    String formatTwoDigits(int value) {
      return value.toString().padLeft(2, "0");
    }

    return {
      "id": media["id"],
      "title": {
        "romaji": _removeBadItems(media["title"]["romaji"]),
        "english": _removeBadItems(media["title"]["english"])
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
      final animeCustomFields = [
        "episodes"
      ];
      final anime = await _getMediaById(animeId, animeCustomFields);

      if (anime.isEmpty) {
        return {};
      }

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
      final mangaCustomFields = [
        "chapters"
      ];
      final manga = await _getMediaById(mangaId, mangaCustomFields);

      if (manga.isEmpty) {
        return {};
      }

      return {
        ..._sharedInfo(manga),
        "chapters": manga["chapters"]
      };

    } catch (e) {
      return {};
    }
  }

  // Public methods
  @override
  Future<List<Map<String, dynamic>>> getOptions(String name) async {
    return _getMediaOptions(name);
  }

  @override
  Future<Map<String, dynamic>> getInfo(String id) async {
    if (_mediaType == "ANIME") {
      return _getAnimeInfo(id);
    }
    else {
      return _getMangaInfo(id);
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getRecommendations(int) async {
    return [];
  }
}
