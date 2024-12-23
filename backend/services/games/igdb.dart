import 'dart:async';
import 'dart:convert';
import '../provider.dart';
import 'package:numerus/numerus.dart';
import 'package:http/http.dart' as http;

class IGDB extends Provider {
  // Members
  late final Map<String, String> _params;
  String _accessToken = '';
  String _cover = '';
  final List<String> _artworks = [];
  final List<String> _collections = [];
  final List<dynamic> _developers = [];
  final List<String> _franchises = [];
  final List<String> _genres = [];
  final List<dynamic> _platforms = [];
  final List<dynamic> _publishers = [];
  final List<String> _websites = [];

  // Public constructor
  IGDB() {
    _params = {
      'client_id': config.igdbId,
      'client_secret': config.igdbSecret,
      'grant_type': 'client_credentials'
    };
  }

  // Private methods
  Map<String, String> _authHeaders(String accessToken) {
    return {
      'Client-ID': config.igdbId,
      'Authorization': 'Bearer $accessToken',
    };
  }

  Future<http.Response?> _makeRequest(String endpoint, { required Map<String, String> headers, required String body }) async {
    final url = Uri.parse('https://api.igdb.com/v4/$endpoint');
    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        return response;
      }
      else {
        print('${response.statusCode} - $endpoint $body');
        return null;
      }
    }
    catch (e) {
      return null;
    }
  }

  Future<String> _getAccessToken() async {
    try {
      final url = Uri.parse('https://id.twitch.tv/oauth2/token');
      final response = await http.post(url, body: _params);
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['access_token'];
      }
      else {
        return '';
      }
    }
    catch (e) {
      return '';
    }
  }

  String _formatIds(Map<String, dynamic> game, String key) {
    var ids = [];
    for (int i = 0; i < game[key].length; ++i) {
      ids.add('${game[key][i]}');
    }
    return '(${ids.join(", ")})';
  }

  Future<void> _getArtworks(String accessToken, Map<String, dynamic> game) async {
    try {
      final response = await _makeRequest(
        'artworks',
        headers: _authHeaders(accessToken),
        body: 'fields url; where id = ${_formatIds(game, 'artworks')};'
      );

      if (response != null) {
        for (var artwork in jsonDecode(response.body)) {
          _artworks.add(artwork['url'].replaceFirst('thumb', 'original'));
        }
      }
    }
    catch (_) {}
  }

  Future<void> _getCover(String accessToken, Map<String, dynamic> game) async {
    try {
      final response = await _makeRequest(
        'covers',
        headers: _authHeaders(accessToken),
        body: 'fields url; where id = ${game['cover']};'
      );
      if (response != null) {
        _cover = jsonDecode(response.body)[0]['url'].replaceFirst('thumb', 'original');
      }
    }
    catch (_) {}
  }

  Future<void> _getCollections(String accessToken, Map<String, dynamic> game) async {
    try {
      if (game['collection'] != null) {
        game['collections'].add(game['collection']);
        game.remove('collection');
      }

      final response = await _makeRequest(
        'collections',
        headers: _authHeaders(accessToken),
        body: 'fields name; where id = ${_formatIds(game, 'collections')};'
      );

      if (response != null) {
        for (var collection in jsonDecode(response.body)) {
          _collections.add(utf8.decode(collection['name'].runes.toList()));
        }
      }
    }
    catch (_) {}
  }

  Future<void> _getCompanies(String accessToken, Map<String, dynamic> game) async {
    try {
      await _getDevelopersAndPublishers(accessToken, game);
      var idsArray = [];
      for (var developer in _developers) {
        idsArray.add(developer);
      }
      for (var publisher in _publishers) {
        idsArray.add(publisher);
      }
      var ids = '(${idsArray.join(", ")})';

      final response = await _makeRequest(
        'companies',
        headers: _authHeaders(accessToken),
        body: 'fields name; where id = $ids;'
      );

      if (response != null) {
        for (var company in jsonDecode(response.body)) {
          if (_developers.contains(company['id'])) {
            _developers.add(utf8.decode(company['name'].runes.toList()));
          }
          if (_publishers.contains(company['id'])) {
            _publishers.add(utf8.decode(company['name'].runes.toList()));
          }
        }
        for (int i = 0; i < _developers.length; ++i) {
          if (_developers[i] is int) {
            _developers.removeAt(i);
            i--;
          }
        }
        for (int i = 0; i < _publishers.length; ++i) {
          if (_publishers[i] is int) {
            _publishers.removeAt(i);
            i--;
          }
        }
      }
    }
    catch (_) {}
  }

  Future<void> _getDevelopersAndPublishers(String accessToken, Map<String, dynamic> game) async {
    try {
      final response = await _makeRequest(
        'involved_companies',
        headers: _authHeaders(accessToken),
        body: 'fields company,developer,publisher; where id = ${_formatIds(game, 'involved_companies')} & (developer = true | publisher = true);'
      );

      if (response != null) {
        for (var company in jsonDecode(response.body)) {
          if (company['developer'] == true) {
            _developers.add(company['company']);
          }
          if (company['publisher'] == true) {
            _publishers.add(company['company']);
          }
        }
      }
    }
    catch (_) {}
  }

  Future<void> _getFranchises(String accessToken, Map<String, dynamic> game) async {
    try {
      if (game['franchise'] != null) {
        game['franchises'].add(game['franchise']);
        game.remove('franchise');
      }

      final response = await _makeRequest(
        'franchises',
        headers: _authHeaders(accessToken),
        body: 'fields name; where id = ${_formatIds(game, 'franchise')};'
      );

      if (response != null) {
        for (var franchise in jsonDecode(response.body)) {
          _franchises.add(utf8.decode(franchise['name'].runes.toList()));
        }
      }
    }
    catch (_) {}
  }

  Future<void> _getGenres(String accessToken, Map<String, dynamic> game) async {
    try {
      final response = await _makeRequest(
        'genres',
        headers: _authHeaders(accessToken),
        body: 'fields name; where id = ${_formatIds(game, 'genres')};'
      );

      if (response != null) {
        for (var genre in jsonDecode(response.body)) {
          _genres.add(utf8.decode(genre['name'].runes.toList()));
        }
      }
    }
    catch (_) {}
  }

  Future<void> _getPlatforms(String accessToken, Map<String, dynamic> game) async {
    try {
      final response = await _makeRequest(
        'platforms',
        headers: _authHeaders(accessToken),
        body: 'fields name; where id = ${_formatIds(game, 'platforms')};'
      );

      if (response != null) {
        for (var platform in jsonDecode(response.body)) {
          _platforms.add(utf8.decode(platform['name'].runes.toList()));
        }
      }
    }
    catch (_) {}
  }

  Future<void> _getWebsites(
      String accessToken, Map<String, dynamic> game) async {
    try {
      final response = await _makeRequest(
        'websites',
        headers: _authHeaders(accessToken),
        body: 'fields url; where game = ${game['id']};'
      );

      if (response != null) {
        for (var website in jsonDecode(response.body)) {
          _websites.add(website['url']);
        }
      }
    }
    catch (_) {}
  }

  bool _containsAllWords(String name, String gameName) {
    final words = gameName.replaceAll(':', '').split(' ');
    for (var word in words) {
      if (!name.toLowerCase().contains(word.toLowerCase())) {
        return false;
      }
    }
    return true;
  }

  List<dynamic> _filterGames(games) {
    final badWords = ['bundle', 'pack'];
    return games
        .where((game) => !badWords.any((word) => game['name'].toLowerCase().contains(word)))
        .toList();
  }

  Future<List<Map<String, dynamic>>> _getGameOptions(String gameName) async {
    try {
      _accessToken = await _getAccessToken();

      final response = await _makeRequest(
        'games',
        headers: _authHeaders(_accessToken),
        body: 'fields id,first_release_date,name; search "$gameName";'
        // where version_parent = null & parent_game = null
      );

      if (response == null || response.body == '[]') {
        return [{'error': 'No games found'}];
      }

      var games = jsonDecode(response.body);

      games = _filterGames(games)
          .where((game) => _containsAllWords(game['name'], gameName))
          .toList();

      for (int i = 0; i < games.length; ++i) {
        games[i]['name'] = utf8.decode(games[i]['name'].runes.toList());
        if (games[i]['first_release_date'] != null) {
          // Turn the Unix timestamp into a DateTime object
          final releaseDate = DateTime.fromMillisecondsSinceEpoch(games[i]['first_release_date'] * 1000);

          // Add the year to the game name
          games[i]['name'] += ' (${releaseDate.year})';

          // Delete the 'first_release_date' key
          games[i].remove('first_release_date');
        }
      }

      // Handle games with roman numerals
      final regex = RegExp(r'(\d+)$');
      final match = regex.firstMatch(gameName);
      if (match != null) {
        final numberString = match.group(1);
        if (numberString != null) {
          final roman = int.parse(numberString).toRomanNumeralString() ?? '';
          final extraGames = await _getGameOptions(gameName.replaceFirst(numberString, roman));
          games.addAll(extraGames);
        }
      }
      return List<Map<String, dynamic>>.from(games);
    }
    catch (e) {
      return [{'error': e.toString()}];
    }
  }

  Future<List<Map<String, dynamic>>> _getSimilarGames(String gameId) async {
    _accessToken = await _getAccessToken();

    final response = await _makeRequest(
        'games',
        headers: _authHeaders(_accessToken),
        body: 'fields similar_games; where id = $gameId;'
      );

    if (response == null || response.body == '[]') {
      return [{'error': 'No games found'}];
    }

    var games = jsonDecode(response.body)[0]['similar_games'];

    List<dynamic> ids = [];
    for (var game in games) {
      ids.add(game.toString());
    }

    final similarGamesResponse = await _makeRequest(
      'games',
      headers: _authHeaders(_accessToken),
      body: 'fields id,first_release_date,name; where id = (${ids.join(',')}) & version_parent = null & parent_game = null;'
    );

    if (similarGamesResponse == null) {
      return [{'error': 'No games found'}];
    }

    games = jsonDecode(similarGamesResponse.body);
    for (int i = 0; i < games.length; ++i) {
      games[i]['name'] = utf8.decode(games[i]['name'].runes.toList());
      if (games[i]['first_release_date'] != null) {
        // Turn the Unix timestamp into a DateTime object
        games[i]['first_release_date'] = DateTime.fromMillisecondsSinceEpoch(games[i]['first_release_date'] * 1000);

        // Add the year to the game name
        games[i]['name'] += ' (${games[i]['first_release_date'].year})';

        // Delete the 'first_release_date' key
        games.remove('first_release_date');
      }
    }
    return List<Map<String, dynamic>>.from(games);
  }

  Future<Map<String, dynamic>> _getGameInfo(String gameId) async {
    try
    {
      _accessToken = await _getAccessToken();

      final response = await _makeRequest(
        'games',
        headers: _authHeaders(_accessToken),
        body: 'fields id,aggregated_rating,artworks,collection,collections,cover,dlcs,first_release_date,franchise,genres,involved_companies,name,platforms,rating,remakes,remasters,summary,url,websites; where id = $gameId;'
      );

      if (response == null) {
        return {'error': 'No games found'};
      }

      var game = jsonDecode(response.body)[0];
      game['originalname'] = utf8.decode(game['name'].runes.toList());
      game.remove('name');

      if (game['first_release_date'] != null) {
        // Turn the Unix timestamp into a DateTime object
        game['first_release_date'] = DateTime.fromMillisecondsSinceEpoch(game['first_release_date'] * 1000);

        // Add the year to the game name
        game['originalname'] += ' (${game['first_release_date'].year})';

        // Format the date as a string, removing the time
        game['releasedate'] = DateTime.parse(game['first_release_date'].toString().substring(0, 10));

        // Delete the 'first_release_date' key
        game.remove('first_release_date');
      }

      if (game['summary'] != null) {
        game['description'] = utf8.decode(game['summary'].runes.toList());
        game.remove('summary');
      }

      if (game['aggregated_rating'] != null) {
        game['criticscore'] = (game['aggregated_rating']).round();
        game.remove('aggregated_rating');
      }
      else {
        game['criticscore'] = 0;
        game.remove('aggregated_rating');
      }

      if (game['artworks'] != null) {
        await _getArtworks(_accessToken, game);
        game['artworks'] = _artworks;
      }

      if (game['cover'] != null) {
        await _getCover(_accessToken, game);
        game['coverimage'] = _cover;
        game.remove('cover');
      }

      if (game['collections'] != null) {
        await _getCollections(_accessToken, game);
        game['seriesname'] = _collections;
        game.remove('collections');
      }

      if (game['franchises'] != null) {
        await _getFranchises(_accessToken, game);
        if (game['seriesname'] != null) {
          game['seriesname'] += _franchises;
        }
        else {
          game['seriesname'] = _franchises;
        }
      }

      if (game['genres'] != null) {
        await _getGenres(_accessToken, game);
        game['genres'] = _genres;
      }

      if (game['involved_companies'] != null) {
        await _getCompanies(_accessToken, game);
        game['creators'] = _developers;
        game['publishers'] = _publishers;
        game.remove('involved_companies');
      }

      if (game['platforms'] != null) {
        await _getPlatforms(_accessToken, game);
        game['platforms'] = _platforms;
      }

      if (game['rating'] != null) {
        game['communityscore'] = (game['rating']).round();
        game.remove('rating');
      }
      else {
        game['communityscore'] = 0;
        game.remove('rating');
      }

      if (game['websites'] != null) {
        await _getWebsites(_accessToken, game);
        game['links'] = _websites;
        game.remove('websites');
      }
      return game;
    }
    catch (e) {
      return {'error': e.toString()};
    }
  }

  // Public methods
  @override
  Future<List<Map<String, dynamic>>> getOptions(String gameName) async {
    return _getGameOptions(gameName);
  }

  @override
  Future<Map<String, dynamic>> getInfo(String gameId) async {
    return _getGameInfo(gameId);
  }

  @override
  Future<List<Map<String, dynamic>>> getRecommendations(String gameId) async {
    return _getSimilarGames(gameId);
  }
}
