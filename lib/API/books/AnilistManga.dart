import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../general/Service.dart';

class AnilistManga extends Service {
  // Members
  final _headers = {
    "Content-Type": "application/json"
  };
  final _url = Uri.parse("https://graphql.anilist.co/");

  // Private constructor
  AnilistManga._();

  // Singleton instance
  static final AnilistManga _instance = AnilistManga._();

  // Accessor for the singleton instance
  static AnilistManga get instance => _instance;

  // Private methods
  Future<List<Map<String, dynamic>>> _getManga(String mangaName) async {
    final query = '''
      query {
        Page {
          media(search: "$mangaName", type: MANGA) {
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

        for (var manga in data["data"]["Page"]["media"]) {
          var name;
          if (manga["title"]["english"] != null) {
            name = manga["title"]["english"];
          } else {
            name = manga["title"]["romaji"];
          }

          options.add({
            "id": manga["id"],
            "name": name,
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

  Future<Map<String, dynamic>> _getMangaInfo(int mangaId) async {
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

    try {
      final response = await http.post(
        _url,
        headers: _headers,
        body: json.encode({'query': query}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final manga = data['data']['Media'];

        return {
          "id": manga["id"],
          "title": {
            "romaji": manga["title"]["romaji"],
            "english": manga["title"]["english"],
            "native": manga["title"]["native"],
          },
          "description": manga["description"],
          "start_date": manga["startDate"],
          "genres": manga["genres"],
          "chapters": manga["chapters"],
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
  Future<List<Map<String, dynamic>>> getOptions(String mangaName) async {
    return instance._getManga(mangaName);
  }

  @override
  Future<Map<String, dynamic>> getInfo(Map<String, dynamic> manga) async {
    return instance._getMangaInfo(manga["id"]);
  }

  @override
  Future<List<Map<String, dynamic>>> getRecommendations(int mangaId) async {
    return [];
  }
}
