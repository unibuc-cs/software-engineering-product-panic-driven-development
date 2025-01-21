import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../Services/provider_service.dart';

Map<String, dynamic> _getBestMatch(String gameName, List<Map<String, dynamic>> gameOptions) {
  Map<String, dynamic> bestMatch = {};
  int bestMatchPercentage = 0;
  gameName = gameName.replaceAll(RegExp(r'\W'), '').toLowerCase();
  for (final game in gameOptions) {
    if (!game.containsKey('name')) {
      continue;
    }
    String name = game['name']
      .replaceAll(RegExp(r'\(.*?\)'), '')
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

Future<Map<String, dynamic>> _getGamesForID(String id) async {
  if (id.isEmpty) {
    return {};
  }
  final gamesList = (await getInfoSteam(id))['games'];
  final futures = <Future<void>>[];
  Map<String, dynamic> games = {};

  for (var i = 0; i < gamesList.length; i++) {
    futures.add(Future.delayed(Duration(milliseconds: 275 * i), () async {
      final game = gamesList[i];
      final name = (game['name'] ?? '')
        .replaceAll(':', '')
        .replaceAll(',', '')
        .replaceAll('&', 'and')
        .split(RegExp(r'\s+'))
        .join(' ');
      final gameOptions = await getOptionsIGDB(name);
      games[name] = _getBestMatch(name, gameOptions);
    }));
  }
  await Future.wait(futures);
  return games;
}

Future<void> importSteam(BuildContext context) {
  TextEditingController controller = TextEditingController();

  Map<String, dynamic> searchResults = {};

  return showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            content: SizedBox(
              width: 300,
              height: 400,
              child: Column(
                children: [
                  TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      labelText: 'Steam ID',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () async {
                          String query = controller.text;
                          if (query.isNotEmpty) {
                            searchResults = await _getGamesForID(query);
                            if (context.mounted) {
                              setState(() {});
                            }
                          }
                        },
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        for (var entry in searchResults.entries)
                          Text(entry.key),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      );
    }
  );
}
