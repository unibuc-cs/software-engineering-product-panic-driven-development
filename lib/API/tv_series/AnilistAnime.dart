import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../general/Service.dart';

class AnilistAnime extends Service {
  // Members
  final _headers = {
    "Content-Type": "application/json"
  };
  final _url = Uri.parse("https://graphql.anilist.co/");

  // Private constructor
  AnilistAnime._();

  // Singleton instance
  static final AnilistAnime _instance = AnilistAnime._();

  // Accessor for the singleton instance
  static AnilistAnime get instance => _instance;

  // Private methods
  Future<List<Map<String, dynamic>>> _getAnime(String animeName) async {
    final query = '''
      query {
        Page {
          media(search: "$animeName", type: ANIME) {
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
        body: json.encode({'query': query}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final options = <Map<String, dynamic>>[];

        for (var anime in data["data"]["Page"]["media"]) {
          var name;
          if (anime["title"]["english"] != null) {
            name = anime["title"]["english"];
          } else {
            name = anime["title"]["romaji"];
          }

          options.add({
            "id": anime["id"],
            "name": name
          });
        }

        return options;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>> _getAnimeInfo(String animeId) async {
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

    try {
      final response = await http.post(
        _url,
        headers: _headers,
        body: json.encode({'query': query}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final anime = data['data']['Media'];

        return {
          "id": anime["id"],
          "title": {
            "romaji": anime["title"]["romaji"],
            "english": anime["title"]["english"],
            "native": anime["title"]["native"],
          },
          "description": anime["description"],
          "start_date": anime["startDate"],
          "genres": anime["genres"],
          "episodes": anime["episodes"],
        };
      } else {
        return {};
      }
    } catch (e) {
      return {};
    }
  }

  // Public methods
  @override
  Future<List<Map<String, dynamic>>> getOptions(String animeName) async {
    return instance._getAnime(animeName);
  }

  @override
  Future<Map<String, dynamic>> getInfo(String animeId) async {
    return instance._getAnimeInfo(animeId);
  }

  @override
  Future<List<Map<String, dynamic>>> getRecommendations(int animeId) async {
    return [];
  }
}
