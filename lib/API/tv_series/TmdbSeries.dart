import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../general/Service.dart';

class TmdbSeries extends Service {
  // Members
  late final _headers;
  final _searchUrl = Uri.parse("https://api.themoviedb.org/3/search/tv");
  final _detailsUrl = "https://api.themoviedb.org/3/tv/";

  // Private constructor
  TmdbSeries._() {
    _headers = {
      "accept": "application/json",
      "Authorization": "Bearer ${env['ACCESS_TOKEN_TMDB']}"
    };
  }

  // Singleton instance
  static final TmdbSeries _instance = TmdbSeries._();

  // Accessor for the singleton instance
  static TmdbSeries get instance => _instance;

  // Private methods
  Future<Map<String, dynamic>> _getEpisodesPerSeason(String seriesId) async {
    try {
      final url = Uri.parse("https://api.themoviedb.org/3/tv/$seriesId");
      final response = await http.get(url, headers: _headers);
      if (response.statusCode == 200) {
        final series = json.decode(response.body);
        final seasonsInfo = <String, int>{};

        for (var season in series["seasons"]) {
          if (season["season_number"] != 0) {
            seasonsInfo[season["season_number"].toString()] = season["episode_count"];
          }
        }
        return seasonsInfo;
      } 
      else {
        return {};
      }
    }
    catch (e) {
      return {};
    }
  }

  Future<List<Map<String, dynamic>>> _getSeries(String seriesName) async {
    try {
      final params = {
        "query": Uri.encodeQueryComponent(seriesName)
      };
      final response = await http.get(_searchUrl.replace(queryParameters: params), headers: _headers);

      if (response.statusCode == 200) {
        final series = json.decode(response.body);

        final options = <Map<String, dynamic>>[];
        for (var tvSeries in series["results"]) {
          options.add({
            "id": tvSeries["id"],
            "name": tvSeries["name"],
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

  Future<Map<String, dynamic>> _getDetails(String seriesId) async {
    try {
      final params = {
        "language": Uri.encodeQueryComponent("en-US")
      };
      final response = await http.get(Uri.parse(_detailsUrl + seriesId).replace(queryParameters: params), headers: _headers);

      if (response.statusCode == 200) {
        final details = json.decode(response.body);

        // image url: https://image.tmdb.org/t/p/original
        return {
          "name": details["name"],
          "description": details["overview"],
          "language": details["original_language"],
          "artwork": details["backdrop_path"],
          "cover": details["poster_path"],
          "producers": details["production_companies"].map((dynamic producer) {
              return producer["name"];
            }).toList(),
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
  Future<List<Map<String, dynamic>>> getOptions(String seriesName) async {
    return instance._getSeries(seriesName);
  }

  @override
  Future<Map<String, dynamic>> getInfo(String seriesId) async {
    final series = await instance._getDetails(seriesId);
    final seasonsInfo = await instance._getEpisodesPerSeason(seriesId);

    if (!seasonsInfo.isEmpty) {
      series["seasons"] = seasonsInfo;
    }
    return series;
  }

  @override
  Future<List<Map<String, dynamic>>> getRecommendations(int seriesId) async {
    return [];
  }
}