import 'dart:async';
import 'dart:convert';
import '../provider.dart';
import 'package:http/http.dart' as http;

class Tmdb extends Provider {
  // Members
  late final _headers;
  String _mediaType = "";

  // Public constructor
  Tmdb({required String mediaType}) : _mediaType = mediaType {
     _headers = {
      "accept": "application/json",
      "Authorization": "Bearer ${config.tmdb_token}"
    };
  }

  // Private methods
  Future<Map<String, dynamic>> _getResponse(Map<String, dynamic> params, String url) async {
    try {
      final response = await http.get(
        Uri.parse(url).replace(queryParameters: params),
        headers: _headers,
      );

      if (response.statusCode != 200) {
        return {};
      }

      return json.decode(response.body);
    }
    catch (e) {
      return {};
    }
  }

  Future<List<Map<String, dynamic>>> _getMediaOptions(String name) async {
    try {
      final params = {
        "query": Uri.encodeQueryComponent(name)
      };
      final url = "https://api.themoviedb.org/3/search/$_mediaType";
      final response = await _getResponse(params, url);

      if (response.isEmpty) {
        return [];
      }

      return (response["results"] as List).map((media) {
        return {
          "id": media["id"],
          "name": media[_mediaType == "movie" ? "title" : "name"]
        };
      }).toList();
    }
    catch (e) {
      return [{ "error": e.toString() }];
    }
  }

  Future<Map<String, dynamic>> _getMediaById(String id) async {
    try {
      final params = {
        "language": Uri.encodeQueryComponent("en-US")
      };
      final url = "https://api.themoviedb.org/3/$_mediaType/$id";
      final response = await _getResponse(params, url);

      if (response.isEmpty) {
        return {};
      }

      return response;
    }
    catch (e) {
      return {"error": e.toString()};
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
        return {"error": "Movie not found"};
      }
      if (movie.containsKey("error")) {
        return movie;
      }

      return {
        ..._sharedInfo(movie),
        "collection": (movie["belongs_to_collection"] as Map<String, dynamic>?)?["name"] ?? null,
        "release_date": movie["release_date"],
        "duration": movie["runtime"]
      };
    }
    catch (e) {
      return {"error": e.toString()};
    }
  }

  Future<Map<String, dynamic>> _getSeriesInfo(String seriesId) async {
    try {
      final series = await _getMediaById(seriesId);

      if (series.isEmpty) {
        return {"error": "Series not found"};
      }
      if (series.containsKey("error")) {
        return series;
      }

      return {
        ..._sharedInfo(series),
      };
    }
    catch (e) {
      return {"error": e.toString()};
    }
  }

   Future<List<Map<String, dynamic>>> _getMediaRecommendations(String id) async {
    try {
      final params = {
        "language": Uri.encodeQueryComponent("en-US"),
      };
      final url = "https://api.themoviedb.org/3/$_mediaType/$id/recommendations";
      final response = await _getResponse(params, url);

      if (response.isEmpty) {
        return [];
      }

      return (response["results"] as List).map((media) {
        return {
          "id": media["id"],
          "name": media[_mediaType == "movie" ? "title" : "name"]
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
    if (_mediaType == 'movie') {
      return _getMovieInfo(id);
    }
    else {
      return _getSeriesInfo(id);
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getRecommendations(String id) async {
    return _getMediaRecommendations(id);
  }
}
