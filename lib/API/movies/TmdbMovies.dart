import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../general/Service.dart';

class TmdbMovies extends Service {
  // Members
  late final _headers;
  final _searchUrl = Uri.parse("https://api.themoviedb.org/3/search/movie");
  final _detailsUrl = "https://api.themoviedb.org/3/movie/";

  // Private constructor
  TmdbMovies._() {
    _headers = {
      "accept": "application/json",
      "Authorization": "Bearer ${env['ACCESS_TOKEN_TMDB']}"
    };
  }

  // Singleton instance
  static final TmdbMovies _instance = TmdbMovies._();

  // Accessor for the singleton instance
  static TmdbMovies get instance => _instance;

  // Private methods
  Future<List<Map<String, dynamic>>> _getMovies(String movieName) async {
    try {
      final params = {
        "query": Uri.encodeQueryComponent(movieName)
      };
      final response = await http.get(_searchUrl.replace(queryParameters: params), headers: _headers);

      if (response.statusCode == 200) {
        final movies = json.decode(response.body);

        final options = <Map<String, dynamic>>[];
        for (var movie in movies["results"]) {
          options.add({
            "name": movie["title"],
            "id": movie["id"]
          });
        }
        return options;
      }
      else {
        return [];
      }
    }
    catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>> _getDetails(String movieId) async {
    try {
      final params = {
        "language": Uri.encodeQueryComponent("en-US")
      };
      final response = await http.get(Uri.parse(_detailsUrl + movieId).replace(queryParameters: params), headers: _headers);

      if (response.statusCode == 200) {
        final details = json.decode(response.body);

        // image url: https://image.tmdb.org/t/p/original
        return {
          "name": details["title"],
          "description": details["overview"],
          "collection": (details["belongs_to_collection"] as Map<String, dynamic>?)?["name"] ?? null,
          "language": details["original_language"],
          "artwork": details["backdrop_path"],
          "cover": details["poster_path"],
          "producers": details["production_companies"].map((dynamic producer) {
              return producer["name"];
            }).toList(),
          "release_date": details["release_date"],
          "duration": details["runtime"],
          "status": details["status"],
          "community_rating": details["vote_average"]
        };
      }
      else {
        print(response.reasonPhrase);
        return {};
      }
    }
    catch (e) {
      print(e);
      return {};
    }
  }

  // Public methods
  @override
  Future<List<Map<String, dynamic>>> getOptions(String movieName) async {
    return instance._getMovies(movieName);
  }

  @override
  Future<Map<String, dynamic>> getInfo(String movieId) async {
    return instance._getDetails(movieId);
  }

  @override
  Future<List<Map<String, dynamic>>> getRecommendations(int movieId) async {
    return [];
  }
}