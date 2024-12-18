import 'dart:async';
import 'dart:convert';
import '../provider.dart';
import 'package:http/http.dart' as http;

class Anilist extends Provider {
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
    }
    catch (e) {
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
        return [{"error": "No media found"}];
      }

      return (response["Page"]["media"] as List).map((media) {
        return {
          "id": media["id"],
          // Prefer the English title, fallback to the Japanese one
          "name": _removeBadItems(media["title"]["english"] ?? media["title"]["romaji"])
        };
      }).toList();
    }
    catch (e) {
      return [{"error": e.toString()}];
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
            coverImage {
              large
            }
            meanScore
            averageScore
            status
            externalLinks {
              url
            }
            ${customFields.join("\n")}
          }
        }
      ''';
      final response = await _getResponse(query);

      if (response.isEmpty) {
        return {};
      }

      return response["Media"];
    }
    catch (e) {
      return {"error": e.toString()};
    }
  }

  Map<String, dynamic> _sharedInfo(Map<String, dynamic> media) {
    String formatTwoDigits(int value) {
      return value.toString().padLeft(2, "0");
    }

    return {
      "id": media["id"],
      "originalname": _removeBadItems(media["title"]["english"] ?? media["title"]["romaji"]),
      "description": _removeBadItems(media["description"] ?? ""),
      "releasedate": DateTime.parse(
        '${media["startDate"]["year"]}-'
        '${formatTwoDigits(media["startDate"]["month"] ?? 1)}-'
        '${formatTwoDigits(media["startDate"]["day"] ?? 1)}'
      ),
      "genres": media["genres"],
      "coverimage": media["coverImage"]["large"],
      "communityscore": media["meanScore"],
      "criticscore": media["averageScore"],
      "status": media["status"],
      "links": media["externalLinks"].map((link) => link["url"]).toList()
    };
  }

  Future<Map<String, dynamic>> _getAnimeInfo(String animeId) async {
    try {
      final animeCustomFields = [
        "episodes",
        "duration"
      ];
      final anime = await _getMediaById(animeId, animeCustomFields);

      if (anime.isEmpty) {
        return {"error": "No anime found"};
      }
      if (anime.containsKey("error")) {
        return anime;
      }

      return {
        ..._sharedInfo(anime),
        "episodes": anime["episodes"],
        "duration": anime["duration"]
      };
    }
    catch (e) {
      return {"error": e.toString()};
    }
  }

  Future<Map<String, dynamic>> _getMangaInfo(String mangaId) async {
    try {
      final mangaCustomFields = [
        "chapters",
        "volumes"
      ];
      final manga = await _getMediaById(mangaId, mangaCustomFields);

      if (manga.isEmpty) {
        return {"error": "No manga found"};
      }
      if (manga.containsKey("error")) {
        return manga;
      }

      return {
        ..._sharedInfo(manga),
        "chapters": manga["chapters"],
        "volumes": manga["volumes"]
      };
    }
    catch (e) {
      return {"error": e.toString()};
    }
  }

  Future<List<Map<String, dynamic>>> _getMediaRecommendations(String id) async {
    try {
      final query = '''
        query {
          Media(id: $id) {
            recommendations {
              edges {
                node {
                  mediaRecommendation {
                    id
                    title {
                      romaji
                      english
                    }
                    type
                  }
                }
              }
            }
          }
        }
      ''';

      final response = await _getResponse(query);

      if (response.isEmpty) {
        return [{"error": "No recommendations found"}];
      }

      final recommendations = response["Media"]["recommendations"]["edges"];
      if (recommendations == null || recommendations.isEmpty) {
        return [{"error": "No recommendations found"}];
      }

      return (recommendations as List).map((edge) {
        final recommendation = edge["node"]["mediaRecommendation"];
        return {
          "id": recommendation["id"],
          "name": _removeBadItems(recommendation["title"]["english"] ?? recommendation["title"]["romaji"])
        };
      }).toList();
    }
    catch (e) {
      return [{"error": e.toString()}];
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
  Future<List<Map<String, dynamic>>> getRecommendations(String id) async {
    return _getMediaRecommendations(id);
  }
}
