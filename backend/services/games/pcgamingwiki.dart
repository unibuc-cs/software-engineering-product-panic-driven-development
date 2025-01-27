import 'dart:async';
import 'dart:convert';
import '../provider.dart';
import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

class PcGamingWiki extends Provider {
  // Members
  final _queries = [
    'windows',
    'os_x',
    'linux'
  ];

  // Private constructor
  PcGamingWiki._();

  // Singleton instance
  static final PcGamingWiki _instance = PcGamingWiki._();

  // Accessor for the singleton instance
  static PcGamingWiki get instance => _instance;

  // Private methods
  Future<List<Map<String, dynamic>>> _getGameOptions(String gameName) async {
    try {
      // some games can't be found when the name contains -
      gameName = gameName.replaceAll('-', ' ');

      final url = 'https://www.pcgamingwiki.com/w/api.php?action=query&format=json&list=search&srsearch=$gameName';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        return [];
      }

      final games = jsonDecode(response.body);

      if (!games.containsKey('query') || !games['query'].containsKey('search')) {
        return [{'error': 'No games found'}];
      }

      return (games['query']['search'] as List).map((game) {
          if (game['snippet'].contains('REDIRECT')) {
            // Example: '#REDIRECT [[<span class='searchmatch'>Blasphemous</span> 2]]\n' -> Blasphemous 2
            game['title'] = '';
            final parts = game['snippet'].split('</span>');
            for (var part in parts) {
              if (part.contains('>')) {
                game['title'] += part.split('>')[1] + ' ';
              }
            }
            game['title'] += parts.last.substring(0, parts.last.length - 3).trim();
          }
          return {
            'name': game['title'].trim()
          };
        }).fold<List<Map<String, dynamic>>>([], (uniqueOptions, option) {
          // Prevent duplicates
          if (!uniqueOptions.any((game) => game['name'] == option['name'])) {
            uniqueOptions.add(option);
          }
          return uniqueOptions;
        });
    }
    catch (e) {
      return [{'error': e.toString()}];
    }
  }

  Future<Map<String, dynamic>> _getGameInfo(String gameName) async {
    try {
      final url = 'https://www.pcgamingwiki.com/wiki/${gameName.replaceAll(' ', '_')}';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        return {'error': 'Game not found'};
      }

      final document = parse(response.body);
      Map<String, dynamic> gameInfo = {
        'link': url,
      };

      for (var query in _queries) {
        final sysReqsTable = document.querySelector('.pcgwikitable#table-sysreqs-$query');
        if (sysReqsTable == null) {
          continue;
        }

        Map<String, dynamic> sysReqs = {};
        List<Element> rows = sysReqsTable.querySelectorAll('.template-infotable-body, .table-sysreqs-body-row');

        for (var row in rows) {
          final fullCategory = row.querySelector('.table-sysreqs-body-parameter')?.text.trim() ?? '';
          final category = fullCategory.contains('(') ? fullCategory.split('(')[1].split(')')[0] : fullCategory;

          final minimumReq = row.querySelector('.table-sysreqs-body-minimum')?.text.trim() ?? '';
          final recommendedReq = row.querySelector('.table-sysreqs-body-recommended')?.text.trim() ?? '';

          if (minimumReq.isNotEmpty || recommendedReq.isNotEmpty) {
            sysReqs[category] = {
              'minimum'    : (minimumReq != '') ? minimumReq : null,
              'recommended': (recommendedReq != '') ? recommendedReq : null
            };
          }
        }
        if (sysReqs.isNotEmpty) {
          gameInfo[query] = sysReqs;
        }
      }

      return gameInfo.isNotEmpty ? gameInfo : {};
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
  Future<Map<String, dynamic>> getInfo(String gameName) async {
    return instance._getGameInfo(gameName);
  }

  @override
  Future<List<Map<String, dynamic>>> getRecommendations(String _) async {
    return [];
  }

  @override
  String getKey() {
    return 'name';
  }
}
