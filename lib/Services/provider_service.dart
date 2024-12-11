import 'dart:convert';
import 'package:http/http.dart' as http;

final baseUrl = const bool.fromEnvironment("LOCAL", defaultValue: false)
  ? "http://localhost:3007/api"
  : "https://mediamaster.fly.dev/api";

Future<dynamic> _fetchEndpoint(String endpoint) async {
  final response = await http.get(Uri.parse('$baseUrl/$endpoint'));
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  }
  return null;
}

Future<List<Map<String, dynamic>>> _fetchOptions(String serviceName, String query) async {
  final data = await _fetchEndpoint("$serviceName/options?name=$query");
  if (data is List) {
    return List<Map<String, dynamic>>.from(data);
  }
  return [];
}

Future<Map<String, dynamic>> _fetchInfo(String serviceName, String query) async {
  final data = await _fetchEndpoint("$serviceName/info?id=$query");
  if (data is Map) {
    return Map<String, dynamic>.from(data);
  }
  return {};
}

Future<List<Map<String, dynamic>>> _fetchRecommendations(String serviceName, String query) async {
  final data = await _fetchEndpoint("$serviceName/recommendations?id=$query");
  if (data is List) {
    return List<Map<String, dynamic>>.from(data);
  }
  return [];
}

// IGDB, key is id
Future<List<Map<String, dynamic>>> getOptionsIGDB(String query) async =>
  await _fetchOptions("igdb", query);

Future<Map<String, dynamic>> getInfoIGDB(Map<String, dynamic> game) async =>
  await _fetchInfo("igdb", game["id"].toString());

Future<List<Map<String, dynamic>>> getRecsIGDB (Map<String, dynamic> game) async =>
  await _fetchRecommendations("igdb", game["id"].toString());

// PCGW, key is name
Future<List<Map<String, dynamic>>> getOptionsPCGW(String query) async =>
  await _fetchOptions("pcgamingwiki", query);

Future<Map<String, dynamic>> getInfoPCGW(Map<String, dynamic> game) async =>
  await _fetchInfo("pcgamingwiki", game["name"]);

// HLTB, key is link
Future<List<Map<String, dynamic>>> getOptionsHLTB(String query) async =>
  await _fetchOptions("howlongtobeat", query);

Future<Map<String, dynamic>> getInfoHLTB(Map<String, dynamic> game) async =>
  await _fetchInfo("howlongtobeat", game["link"]);

// Steam
Future<Map<String, dynamic>> getInfoSteam(String userId) async =>
  await _fetchInfo("steam", userId);

// Goodreads, key is link
Future<List<Map<String, dynamic>>> getOptionsBook(String query) async =>
  await _fetchOptions("goodreads", query);

Future<Map<String, dynamic>> getInfoBook(Map<String, dynamic> book) async =>
  await _fetchInfo("goodreads", book["link"]);

Future<List<Map<String, dynamic>>> getRecsBook(Map<String, dynamic> book) async =>
  await _fetchRecommendations("goodreads", book["link"]);

// TMDB Movies, key is id
Future<List<Map<String, dynamic>>> getOptionsMovie(String query) async =>
  await _fetchOptions("tmdbmovie", query);

Future<Map<String, dynamic>> getInfoMovie(Map<String, dynamic> movie) async =>
  await _fetchInfo("tmdbmovie", movie["id"].toString());

Future<List<Map<String, dynamic>>> getRecsMovie(Map<String, dynamic> movie) async =>
  await _fetchRecommendations("tmdbmovie", movie["id"].toString());

// TMDB Series, key is id
Future<List<Map<String, dynamic>>> getOptionsSeries(String query) async =>
  await _fetchOptions("tmdbseries", query);

Future<Map<String, dynamic>> getInfoSeries(Map<String, dynamic> series) async =>
  await _fetchInfo("tmdbseries", series["id"].toString());

Future<List<Map<String, dynamic>>> getRecsSeries(Map<String, dynamic> series) async =>
  await _fetchRecommendations("tmdbseries", series["id"].toString());

// Anilist Anime, key is id
Future<List<Map<String, dynamic>>> getOptionsAnime(String query) async =>
  await _fetchOptions("anilistanime", query);

Future<Map<String, dynamic>> getInfoAnime(Map<String, dynamic> anime) async =>
  await _fetchInfo("anilistanime", anime["id"].toString());

Future<List<Map<String, dynamic>>> getRecsAnime(Map<String, dynamic> anime) async =>
  await _fetchRecommendations("anilistanime", anime["id"].toString());

// Anilist Manga, key is id
Future<List<Map<String, dynamic>>> getOptionsManga(String query) async =>
  await _fetchOptions("anilistmanga", query);

Future<Map<String, dynamic>> getInfoManga(Map<String, dynamic> manga) async =>
  await _fetchInfo("anilistmanga", manga["id"].toString());

Future<List<Map<String, dynamic>>> getRecsManga(Map<String, dynamic> manga) async =>
  await _fetchRecommendations("anilistmanga", manga["id"].toString());
