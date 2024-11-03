import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../general/Service.dart';

class Tmdb extends Service {
  // Members
  late final _headers;
  final _searchTemplate = "https://api.themoviedb.org/3/search/{media}";
  String _mediaType = "";

  // Private constructor
  Tmdb._() {
    _headers = {
      "accept": "application/json",
      "Authorization": "Bearer ${env['ACCESS_TOKEN_TMDB']}"
    };
  }

  // Singleton instance
  static final Tmdb _instance = Tmdb._();

  // Accessor for the singleton instance
  static Tmdb get instance => _instance;

  // Private methods
  String _formatString(String template, Map<String, String> values) {
    String formatted = template;
    values.forEach((key, value) {
      formatted = formatted.replaceAll('{$key}', value);
    });
    return formatted;
  }

  Future<List<Map<String, dynamic>>> _getMediaOptions(String name) async {
    try {
      final params = {
        "query": Uri.encodeQueryComponent(name)
      };
      final searchUrl = _formatString(_searchTemplate, {'media': _mediaType});
      final response = await http.get(Uri.parse(searchUrl).replace(queryParameters: params), headers: _headers);

      if (response.statusCode != 200) {
        return [];
      }

      return (json.decode(response.body)["results"] as List).map((media) {
        return {
          "id": media["id"],
          "name": media[_mediaType == "movie" ? "title" : "name"]
        };
      }).toList();
    }
    catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>> _getMediaById(String id) async {
    try {
      final params = {
        "language": Uri.encodeQueryComponent("en-US")
      };
      final response = await http.get(Uri
        .parse("https://api.themoviedb.org/3/$_mediaType/$id")
        .replace(queryParameters: params), headers: _headers
      );

      if (response.statusCode != 200) {
        return {};
      }

      return json.decode(response.body);
    } catch (e) {
      return {};
    }
  }

  Map<String, dynamic> _sharedInfo(Map<String, dynamic> media) {
    // Image url: https://image.tmdb.org/t/p/original
    return {
      "name": media[_mediaType == "movie" ? "title" : "name"],
      "description": media["overview"],
      "language": media["original_language"],
      "artwork": media["backdrop_path"],
      "cover": media["poster_path"],
      "producers": media["production_companies"].map((dynamic producer) {
        return producer["name"];
      }).toList(),
      "status": media["status"],
      "community_rating": media["vote_average"]
    };
  }

  Future<Map<String, dynamic>> _getMovieInfo(String movieId) async {
    try {
      final movie = await _getMediaById(movieId);

      if (movie.isEmpty) {
        return {};
      }

      return {
        ..._sharedInfo(movie),
        "collection": (movie["belongs_to_collection"] as Map<String, dynamic>?)?["name"] ?? null,
        "release_date": movie["release_date"],
        "duration": movie["runtime"]
      };
    }
    catch (e) {
      print(e);
      return {};
    }
  }

  Future<Map<String, dynamic>> _getSeriesInfo(String seriesId) async {
    try {
      final series = await _getMediaById(seriesId);

      if (series.isEmpty) {
        return {};
      }

      return {
        ..._sharedInfo(series),
      };
    }
    catch (e) {
      print(e);
      return {};
    }
  }

  // Public methods
  void setMovies() {
    _mediaType = "movie";
  }

  void setSeries() {
    _mediaType = "tv";
  }

  @override
  Future<List<Map<String, dynamic>>> getOptions(String name) async {
    return instance._getMediaOptions(name);
  }

  @override
  Future<Map<String, dynamic>> getInfo(String id) async {
    if (_mediaType == 'movie') {
      return instance._getMovieInfo(id);
    } else {
      return instance._getSeriesInfo(id);
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getRecommendations(int movieId) async {
    return [];
  }
}