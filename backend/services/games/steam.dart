import 'dart:io';
import 'dart:async';
import 'dart:convert';
import '../provider.dart';

class Steam extends Provider {
  // Private constructor
  Steam._();

  // Singleton instance
  static final Steam _instance = Steam._();

  // Accessor for the singleton instance
  static Steam get instance => _instance;

  // Private methods
  String? _getDate(int timestampInSeconds) {
    if (timestampInSeconds == 0) {
      return null;
    }
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestampInSeconds * 1000);
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
  }

  Future<Map<String, dynamic>> _getSteamList(String userId) async {
    try {
      final String url = 'https://api.steampowered.com/IPlayerService/GetOwnedGames/v1/?key=${config.steamKey}&steamid=$userId&include_appinfo=true';
      final response = await HttpClient()
        .getUrl(Uri.parse(url))
        .then((req) => req.close());

      if (response.statusCode != 200) {
        return {'error': 'User not found'};
      }

      final body = await response.transform(utf8.decoder).join();
      final List<dynamic>? games = jsonDecode(body)['response']?['games'];

      if (games == null || games.isEmpty) {
        return {'error': 'No games found'};
      }

      games.sort((game1, game2) => game1['name'].compareTo(game2['name']));
      return {
        // image url: https://cdn.cloudflare.steamstatic.com/steamcommunity/public/images/apps/<id>/<icon>.jpg
        'games': games
          .where((game) =>
            !game['name'].toLowerCase().contains('public test') &&
            !game['name'].toLowerCase().contains('multiplayer') &&
            !game['name'].toLowerCase().contains('open beta'))
          .map((game) {
            return {
              'id': game['appid'],
              'name': game['name']
                .replaceAll('™', '')
                .replaceAll('®', '')
                .replaceAll('GOTY Edition', 'Game of The Year Edition')
                .replaceAll('GOTY', '')
                .replaceAll('Single Player', '')
                .replaceAll(RegExp(r'\(.*?\)'), '')
                .replaceAll('’', '\'')
                .trim(),
              'icon': game['img_icon_url'],
              'time_played': game['playtime_forever'],
              'last_played': _getDate(game['rtime_last_played'] ?? 0)
            };
          })
          .toList()
      };
    }
    catch (e) {
      return {'error': e.toString()};
    }
  }

  // Public methods
  @override
  Future<List<Map<String, dynamic>>> getOptions(String _) async {
    return [];
  }

  @override
  Future<Map<String, dynamic>> getInfo(String userId) async {
    return instance._getSteamList(userId);
  }

  @override
  Future<List<Map<String, dynamic>>> getRecommendations(String _) async {
    return [];
  }
}
