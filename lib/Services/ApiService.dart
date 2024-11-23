import 'dart:convert';
import 'package:http/http.dart' as http;

Future<dynamic> _fetchEndpoint(String endpoint) async {
  final baseUrl = const bool.fromEnvironment('LOCAL', defaultValue: false)
    ? 'http://localhost:8080/api'
    : 'https://mediamaster.fly.dev/api';
  final response = await http.get(Uri.parse('$baseUrl/$endpoint'));

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  }
  return null;
}

Future<List<Map<String, dynamic>>> _fetchOptions(String serviceName, String query) async {
  final data = await _fetchEndpoint('$serviceName/options?name=$query');
  if (data is List) {
    return List<Map<String, dynamic>>.from(data);
  }
  return [];
}

Future<Map<String, dynamic>> _fetchInfo(String serviceName, String query) async {
  final data = await _fetchEndpoint('$serviceName/info?id=$query');
  if (data is Map) {
    return Map<String, dynamic>.from(data);
  }
  return {};
}

Future<List<Map<String, dynamic>>> _fetchRecommendations(String serviceName, String query) async {
  final data = await _fetchEndpoint('$serviceName/recommendations?id=$query');
  if (data is List) {
    return List<Map<String, dynamic>>.from(data);
  }
  return [];
}

// IGDB, key is id
final getOptionsIGDB = (String query) async => await _fetchOptions('igdb', query);
final getInfoIGDB = (Map<String, dynamic> game) async => await _fetchInfo('igdb', game['id'].toString());
final getRecsIGDB = (String id) async => await _fetchRecommendations('igdb', id);

// PCGW, key is name
final getOptionsPCGW = (String query) async => await _fetchOptions('pcgamingwiki', query);
final getInfoPCGW = (Map<String, dynamic> game) async => await _fetchInfo('pcgamingwiki', game['name']);
final getRecsPCGW = (String id) async => await _fetchRecommendations('pcgamingwiki', id);

// HLTB, key is link
final getOptionsHLTB = (String query) async => await _fetchOptions('howlongtobeat', query);
final getInfoHLTB = (Map<String, dynamic> game) async => await _fetchInfo('howlongtobeat', game['link']);
final getRecsHLTB = (String id) async => await _fetchRecommendations('howlongtobeat', id);

// Goodreads, key is link
final getOptionsBook = (String query) async => await _fetchOptions('goodreads', query);
final getInfoBook = (Map<String, dynamic> book) async => await _fetchInfo('goodreads', book['link']);
final getRecsBook = (String id) async => await _fetchRecommendations('goodreads', id);

// TMDB Movies, key is id
final getOptionsMovie = (String query) async => await _fetchOptions('tmdbmovies', query);
final getInfoMovie = (Map<String, dynamic> movie) async => await _fetchInfo('tmdbmovies', movie['id']);
final getRecsMovie = (String id) async => await _fetchRecommendations('tmdbmovies', id);

// TMDB Series, key is id
final getOptionsSeries = (String query) async => await _fetchOptions('tmdbseries', query);
final getInfoSeries = (Map<String, dynamic> series) async => await _fetchInfo('tmdbseries', series['id']);
final getRecsSeries = (String id) async => await _fetchRecommendations('tmdbseries', id);

// Anilist Anime, key is id
final getOptionsAnime = (String query) async => await _fetchOptions('anilistanime', query);
final getInfoAnime = (Map<String, dynamic> anime) async => await _fetchInfo('anilistanime', anime['id']);
final getRecsAnime = (String id) async => await _fetchRecommendations('anilistanime', id);

// Anilist Manga, key is id
final getOptionsManga = (String query) async => await _fetchOptions('anilistmanga', query);
final getInfoManga = (Map<String, dynamic> manga) async => await _fetchInfo('anilistmanga', manga['id']);
final getRecsManga = (String id) async => await _fetchRecommendations('anilistmanga', id);
