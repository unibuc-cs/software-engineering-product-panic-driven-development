import 'dart:io';
import 'dart:async';
import 'dart:convert';
import '../provider.dart';
import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

class HowLongToBeat extends Provider {
  // Members

  // classes for HLTB game time elements
  // example: <li class="GameStats_short__tSJ6I time_70"><h4>Co-Op</h4><h5>1448 Hours</h5></li>
  final _querySelectors = [
    '.GameStats_short__tSJ6I',
    '.GameStats_long__h3afN',
    '.GameStats_full__jz7k7'
  ];

  // HLTB links to ignore
  // example: https://howlongtobeat.com/game/5203/reviews/latest/1
  final _badLinks = [
    'forum',
    'reviews',
    'lists',
    'completions'
  ];

  // Private constructor
  HowLongToBeat._();

  // Singleton instance
  static final HowLongToBeat _instance = HowLongToBeat._();

  // Accessor for the singleton instance
  static HowLongToBeat get instance => _instance;

  // Private methods
  Future<Document> _getDocument(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        return Document.html('');
      }

      return parse(response.body);
    }
    catch (e) {
      return Document.html('');
    }
  }

  Future<Map<String, dynamic>> _gameTimes(Document document) async {
    try {
      var times = <String, dynamic>{};

      for (var selector in _querySelectors) {
        final timeElements = document.querySelectorAll(selector);

        for (var timeElement in timeElements) {
          // Split the text after the first digit, and include it in the second one
          // Single-Player68½ Hours - 274 Hours -> Singleplayer and 68½ - 274 Hours
          final label = timeElement.text.split(RegExp(r'\d'))[0].trim();
          final time = timeElement.text.substring(label.length).trim();

          if (time.contains('-') || label.isEmpty || time.isEmpty) {
            continue;
          }

          times[label] = time.replaceAll('½', '.5');
        }
      }
      return times;
    }
    catch (e) {
      return {'error': e.toString()};
    }
  }

  Future<List<Map<String, dynamic>>> _getGameOptions(String gameName) async {
    try {
      final scriptPath = '${Directory.current.path}\\backend\\services\\games\\howlongtobeat.py';
      var result = await Process.run(
        'python',
        [scriptPath, gameName],
      );

      if (result.exitCode == 0) {
        Map<String, dynamic> gameData = jsonDecode(result.stdout.trim().replaceAll("'", '"'));
        List<Map<String, dynamic>> options = [];
        gameData.forEach((name, id) {
          options.add({
            'name': name,
            'id': id,
          });
        });
        return options;
      }
      else {
        throw Exception('Error running Python script: ${result.stderr}');
      }
    }
    catch (e) {
      return [{'error': e.toString()}];
    }
  }

  Future<Map<String, dynamic>> _getGameInfo(String gameId) async {
    try
    {
      final document = await _getDocument('https://howlongtobeat.com/game/$gameId');

      if (document == Document.html('')) {
        return {'error': '$gameId is a bad query'};
      }

      return await _gameTimes(document);
    }
    catch (e) {
      return {'error': e.toString()};
    }
  }

  // Public methods
  @override
  Future<List<Map<String, dynamic>>> getOptions(String gameName) async {
    return instance._getGameOptions(gameName);
  }

  @override
  Future<Map<String, dynamic>> getInfo(String gameId) async {
    return instance._getGameInfo(gameId);
  }

  @override
  Future<List<Map<String, dynamic>>> getRecommendations(String _) async {
    return [];
  }

  @override
  String getKey() {
    return 'link';
  }
}
