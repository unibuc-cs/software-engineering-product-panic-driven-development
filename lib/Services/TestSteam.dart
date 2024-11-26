import 'dart:io';
import 'dart:async';
import 'dart:convert';
import './ApiService.dart';
import 'dart:math' as math;

String encodeWithDateTime(Map<String, dynamic> data) {
  return const JsonEncoder.withIndent('  ').convert(data.map((key, value) {
    if (value is DateTime) {
      return MapEntry(key, value.toString().substring(0, 10));
    }
    else {
      return MapEntry(key, value);
    }
  }));
}

Map<String, dynamic> getBestMatch(String gameName, List<Map<String, dynamic>> gameOptions) {
  Map<String, dynamic> bestMatch = {};
  int bestMatchPercentage = 0;
  gameName = gameName.replaceAll(RegExp(r'\W'), '').toLowerCase();
  for (final game in gameOptions) {
    String name = game["name"]
      .replaceAll(RegExp(r"\(.*?\)"), "")
      .replaceAll(RegExp(r'\W'), '')
      .toLowerCase();
    int length = math.max(name.length, gameName.length), matchPercentage = 0;
    String paddedGameName = gameName.padRight(length, ' ');
    name = name.padRight(length, '_');
    for (int i = 0; i < length; i++) {
      if (name[i] == paddedGameName[i]) {
        matchPercentage++;
      }
    }
    matchPercentage = (matchPercentage / length * 100).round();
    if (matchPercentage > bestMatchPercentage) {
      bestMatch = game;
      bestMatchPercentage = matchPercentage;
    }
  }
  if (bestMatchPercentage < 50) {
    bestMatch = {};
  }
  return bestMatch;
}

final users = {
  "SKT_Blackspell13": "76561199067194369",
  "The-Winner": "76561198840472293",
  "giulian62": "76561198335146669"
};

Future<Map<String, dynamic>> getGames(String selectedUser) async {
  final userId = users[selectedUser] ?? "";
  final gamesList = (await getInfoSteam(userId))["games"];
  final futures = <Future<void>>[];
  Map<String, dynamic> games = {};

  for (var i = 0; i < gamesList.length; i++) {
    futures.add(Future.delayed(Duration(milliseconds: 275 * i), () async {
      final game = gamesList[i];
      final name = (game["name"] ?? "")
        .replaceAll(":", "")
        .replaceAll(",", "")
        .replaceAll("&", "and")
        .split(RegExp(r'\s+'))
        .join(' ');
      final gameInfo = await getOptionsIGDB(name);
      games[name] = getBestMatch(name, gameInfo);
    }));
  }
  await Future.wait(futures);
  return games;
}

Future<Map<String, dynamic>> getInfoForGames(Map<String, dynamic> games) async {
  final Map<String, dynamic> gameInfo = {};
  final futures = <Future<void>>[];
  int delayTime = 0;

  for (var game in games.entries) {
    if (game.value.containsKey("id")) {
      futures.add(Future.delayed(Duration(milliseconds: 2225 * delayTime), () async {
        gameInfo[game.key] = await getInfoIGDB(game.value);
      }));
      ++delayTime;
    }
  }

  await Future.wait(futures);
  return gameInfo;
}

Future<void> main() async {
  final Stopwatch stopwatch = Stopwatch()..start();

  final games = await getGames("giulian62");
  final gamesInfo = await getInfoForGames(games);

  stopwatch.stop();
  print("Execution completed in ${stopwatch.elapsed.inSeconds} seconds.");
}
