import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';
import '../general/Service.dart';

class HowLongToBeat extends Service {
  // Members

  // classes for HLTB game time elements
  // example: <li class="GameStats_short__tSJ6I time_70"><h4>Co-Op</h4><h5>1448 Hours</h5></li>
  final _querySelectors = [
    ".GameStats_short__tSJ6I",
    ".GameStats_long__h3afN",
    ".GameStats_full__jz7k7"
  ];

  // HLTB links to ignore
  // example: https://howlongtobeat.com/game/5203/reviews/latest/1
  final _badLinks = [
    "forum",
    "reviews",
    "lists",
    "completions"
  ];

  // Private constructor
  HowLongToBeat._();

  // Singleton instance
  static final HowLongToBeat _instance = HowLongToBeat._();

  // Accessor for the singleton instance
  static HowLongToBeat get instance => _instance;

  // Private methods
  Future<Map<String, dynamic>> _gameTimes(Document document) async {
    try {
      var times = <String, dynamic>{};

      for (var selector in _querySelectors) {
        final timeElements = document.querySelectorAll(selector);

        for (var timeElement in timeElements) {
          // Split the text after the first digit, and include it in the second one
          // Single-Player68½ Hours - 274 Hours -> Singleplayer and 68½ - 274 Hours
          final label = timeElement.text.split(RegExp(r"\d"))[0].trim();
          final time = timeElement.text.substring(label.length).trim();

          if (time.contains("-") || label.isEmpty || time.isEmpty) {
            continue;
          }

          times[label] = time.replaceAll("½", ".5");
        }
      }
      return times;
    } catch (e) {
      return {};
    }
  }

  Future<List<String>> _getLinks(String gameName) async {
    try {
      final encodedGameName = Uri.encodeQueryComponent("how long to beat $gameName");
      final response = await http.get(Uri.parse("https://www.google.com/search?q=$encodedGameName"));

      if (response.statusCode != 200) {
        return [];
      }

      final linkList = parse(response.body).querySelectorAll('a[href*="howlongtobeat.com/game/"]');

      // Add the links to a set to remove duplicates
      var linkSet = <String>{};

      for (var item in linkList) {
        String link = item.attributes["href"].toString();

        // Remove google and bad howlongtobeat links
        if (link.contains("www.google") || _badLinks.any((element) => link.contains(element))) {
          continue;
        }

        // /url?q=https://howlongtobeat.com/game/[id]&[other_stuff] -> https://howlongtobeat.com/game/[id]
        link = link.split("/url?q=").last.split("&").first;
        linkSet.add(link);
      }

      return linkSet.toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> _getGameOptions(String gameName) async {
    try {
      final links = await _getLinks(gameName);
      var options = <Map<String, dynamic>>[];
      var fetches = links.map((link) async {
        var response = await http.get(Uri.parse(link));
        if (response.statusCode == 200) {
          final actualGameName = parse(response.body).querySelector(".GameHeader_profile_header__q_PID")?.text;
          if (actualGameName != null) {
            options.add({
              "name": actualGameName,
              "link": link
            });
          }
        }
      });

      await Future.wait(fetches);
      return options;
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>> _getGameInfo(String gameLink) async {
    try
    {
      final response = await http.get(Uri.parse(gameLink));

      if (response.statusCode == 200) {
        return await _gameTimes(parse(response.body));
      }
      else {
        return {};
      }
    } catch (e) {
      return {};
    }
  }

  // Public methods
  @override
  Future<List<Map<String, dynamic>>> getOptions(String gameName) async {
    return instance._getGameOptions(gameName);
  }

  @override
  Future<Map<String, dynamic>> getInfo(String gameLink) async {
    return instance._getGameInfo(gameLink);
  }

  @override
  Future<List<Map<String, dynamic>>> getRecommendations(int) async {
    return [];
  }

  @override
  String getKey() {
    return "link";
  }
}
