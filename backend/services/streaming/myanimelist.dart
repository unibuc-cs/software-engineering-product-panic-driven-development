import 'dart:async';
import 'dart:convert';
import '../provider.dart';
import 'package:http/http.dart' as http;

class MyAnimeList extends Provider {
  // Members
  late final String _mediaType;

  // Public constructor
  MyAnimeList({required String mediaType}): _mediaType = mediaType;

  // Private methods
  Uri _url(String username) {
    return Uri.parse('https://myanimelist.net/${_mediaType}list/$username/load.json?status=1');
  }

  Future<Map<String, dynamic>> _getMediaList(String username) async {
    try {
      final data = jsonDecode((await http.get(_url(username))).body);
      if (data.contains('errors')) {
        return {
          _mediaType: []
        };
      }
      String englishKey = _mediaType == 'manga' ? 'manga_english' : 'anime_title_eng';
      return {
        _mediaType: (data as List)
          .map((media) => { 'name': (media[englishKey] != null && media[englishKey]!.isNotEmpty)
            ? media[englishKey]
            : media['${_mediaType}_title'] })
          .toList()
      };
    }
    catch (e) {
      return {
        _mediaType: []
      };
    }
  }

  // Public methods
  @override
  Future<List<Map<String, dynamic>>> getOptions(String _) async {
    return [];
  }

  @override
  Future<Map<String, dynamic>> getInfo(String username) async {
    return await _getMediaList(username);
  }

  @override
  Future<List<Map<String, dynamic>>> getRecommendations(String _) async {
    return [];
  }
}