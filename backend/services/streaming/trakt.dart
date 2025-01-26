import 'dart:async';
import 'dart:convert';
import '../provider.dart';
import 'package:http/http.dart' as http;

class Trakt extends Provider {
  // Members
  late final Map<String, String> _headers;
  late final String _mediaType;

  // Public constructor
  Trakt({required String mediaType}): _mediaType = mediaType {
     _headers = {
      'Content-Type'     : 'application/json',
      'trakt-api-key'    : config.traktId,
      'trakt-api-version': '2'
    };
  }

  // Private methods
  Future<Map<String, dynamic>> _getMediaInfo(String userSlug) async {
    final response = await http.get(
      Uri.parse('https://api.trakt.tv/users/$userSlug/watchlist/$_mediaType'),
      headers: _headers
    );
    if (response.statusCode != 200) {
      return {
        _mediaType: []
      };
    }
    return {
      _mediaType: jsonDecode(response.body)
        .map((media) => { 'name': media[media['type']]['title'] })
        .toList()
    };
  }

  // Public methods
  @override
  Future<List<Map<String, dynamic>>> getOptions(String name) async {
    return [];
  }

  @override
  Future<Map<String, dynamic>> getInfo(String userSlug) async {
    return _getMediaInfo(userSlug);
  }

  @override
  Future<List<Map<String, dynamic>>> getRecommendations(String id) async {
    return [];
  }
}
