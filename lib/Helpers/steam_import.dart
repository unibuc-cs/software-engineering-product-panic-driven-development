import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:mediamaster/Library.dart';
import 'package:mutex/mutex.dart';
import '../Services/provider_service.dart';
import 'package:url_launcher/url_launcher.dart';

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

Future<Map<String, Map<String, dynamic>>> _getGamesForID(String id, {bool debugging = false}) async {
  // TODO: Following code is here so testing does not take 1 minute per run. Please remove when done
  if (debugging) {
    Map<String, Map<String, dynamic>> tempAns = {
      '7 Billion Humans': {'id': 83847, 'name': '7 Billion Humans (2018)'},
      'ARK Survival Evolved': {'id': 10239, 'name': 'Ark: Survival Evolved (2017)'},
      'ARK Survival Of The Fittest': {'id': 24412, 'name': 'ARK: Survival of the Fittest (2016)'},
      'Aeterna Noctis': {'id': 144380, 'name': 'Aeterna Noctis (2021)'},
      'Afterimage': {'id': 185642, 'name': 'Afterimage (2023)'},
      'Arma Cold War Assault': {'id': 9775, 'name': 'Arma: Cold War Assault (2011)'},
      'Blasphemous': {'id': 26820, 'name': 'Blasphemous (2019)'},
      'Brawlhalla': {'id': 10233, 'name': 'Brawlhalla (2014)'},
      'Chained Together': {'id': 265111, 'name': 'Chained Together (2024)'},
      'CS2D': {'id': 180339, 'name': 'CS2D (2004)'},
      'Chicken Invaders Universe': {'id': 144460, 'name': 'Chicken Invaders Universe (2021)'},
      'Content Warning': {'id': 294661, 'name': 'Content Warning (2024)'},
      'Battlefield 1': {'id': 18320, 'name': 'Battlefield 1 (2016)'},
      'Cookie Cutter': {'id': 205700, 'name': 'Cookie Cutter (2023)'},
      'Crab Game': {'id': 178351, 'name': 'Crab Game (2021)'},
      'DOOM': {'id': 7351, 'name': 'Doom (2016)'},
      'DOOM + DOOM II': {'id': 313126, 'name': 'Doom + Doom II (2024)'},
      'DOOM Eternal': {'id': 103298, 'name': 'Doom Eternal (2020)'},
      'Company of Heroes 2': {'id': 1369, 'name': 'Company of Heroes 2 (2013)'},
      'Dead by Daylight': {'id': 18866, 'name': 'Dead by Daylight (2016)'},
      'DOOM II': {'id': 313164, 'name': 'Doom II (2024)'},
      'Counter-Strike 2': {'id': 242408, 'name': 'Counter-Strike 2 (2023)'},
      'Death\'s Gambit Afterlife': {'id': 152130, 'name': 'Death\'s Gambit: Afterlife (2018)'},
      'Dear Esther Landmark Edition': {'id': 24051, 'name': 'Dear Esther: Landmark Edition (2016)'},
      'Don\'t Starve Together': {'id': 17832, 'name': 'Don\'t Starve Together (2016)'},
      'Drones The Human Condition': {'id': 30508, 'name': 'Drones: The Human Condition (2016)'},
      'FTL Faster Than Light': {'id': 3075, 'name': 'FTL: Faster Than Light (2012)'},
      'Half-Life': {'id': 228891, 'name': 'Half-Life'},
      'Half-Life 2 Deathmatch': {'id': 9471, 'name': 'Half-Life 2: Deathmatch (2004)'},
      'Drawful 2': {'id': 19083, 'name': 'Drawful 2 (2016)'},
      'Half-Life Deathmatch Source': {'id': 19348, 'name': 'Half-Life Deathmatch: Source (2006)'},
      'Heavy Metal Machines': {'id': 36171, 'name': 'Heavy Metal Machines (2018)'},
      'Hollow Knight': {'id': 14593, 'name': 'Hollow Knight (2017)'},
      'Half-Life 2': {'id': 233, 'name': 'Half-Life 2 (2004)'},
      'Hue': {'id': 18927, 'name': 'Hue (2016)'},
      'Human Resource Machine': {'id': 14545, 'name': 'Human Resource Machine (2015)'},
      'Jagged Alliance Gold': {'id': 14793, 'name': 'Jagged Alliance: Gold Edition (2006)'},
      'Intravenous': {'id': 144379, 'name': 'Intravenous (2021)'},
      'Kingdom Classic': {'id': 13686, 'name': 'Kingdom: Classic (2015)'},
      'Lethal Company': {'id': 212089, 'name': 'Lethal Company (2023)'},
      'Little Nightmares': {'id': 9174, 'name': 'Little Nightmares (2017)'},
      'Mafia': {'id': 325379, 'name': 'Mafia (2020)'},
      'Marvel Rivals': {'id': 294041, 'name': 'Marvel Rivals (2024)'},
      'Kao the Kangaroo Round 2': {'id': 3962, 'name': 'Kao the Kangaroo: Round 2 (2003)'},
      'Left 4 Dead 2': {'id': 124, 'name': 'Left 4 Dead 2 (2009)'},
      'Max Payne': {'id': 18, 'name': 'Max Payne (2001)'},
      'Pankapu': {'id': 24440, 'name': 'Pankapu (2016)'},
      'Path of Exile': {'id': 1911, 'name': 'Path of Exile (2013)'},
      'Quiplash': {'id': 11588, 'name': 'Quiplash (2015)'},
      'Return to Castle Wolfenstein': {'id': 281, 'name': 'Return to Castle Wolfenstein (2001)'},
      'RISK Global Domination': {'id': 121346, 'name': 'Risk: Global Domination (2016)'},
      'Scribble It!': {'id': 120649, 'name': 'Scribble It! (2020)'},
      'Overcooked! 2': {'id': 103341, 'name': 'Overcooked! 2 (2018)'},
      'Summum Aeterna': {'id': 204692, 'name': 'Summum Aeterna (2023)'},
      'Syberia': {'id': 890, 'name': 'Syberia (2002)'},
      'The Escapists': {'id': 9241, 'name': 'The Escapists (2015)'},
      'Terraria': {'id': 1879, 'name': 'Terraria (2011)'},
      'Titan Quest Anniversary Edition': {'id': 32614, 'name': 'Titan Quest Anniversary Edition (2016)'},
      'Syberia 2': {'id': 111160, 'name': 'Syberia 1 & 2 (2018)'},
      'Ultimate Epic Battle Simulator': {'id': 28171, 'name': 'Ultimate Epic Battle Simulator (2017)'},
      'Viscera Cleanup Detail': {'id': 6009, 'name': 'Viscera Cleanup Detail (2015)'},
      'Unrailed!': {'id': 115201, 'name': 'Unrailed! (2019)'},
      'Viscera Cleanup Detail Shadow Warrior': {'id': 16718, 'name': 'Viscera Cleanup Detail: Shadow Warrior (2013)'},
      'Titanfall 2': {'id': 17447, 'name': 'Titanfall 2 (2016)'},
      'Viscera Cleanup Detail Santa"s Rampage': {'id': 5564, 'name': 'Viscera Cleanup Detail: Santa"s Rampage (2013)'},
      'We Were Here Expeditions The FriendShip': {'id': 266676, 'name': 'We Were Here Expeditions: The FriendShip (2023)'},
      'tModLoader': {'id': 134157, 'name': 'tModLoader (2020)'},
    };
    return tempAns;
  }
  // TODO: Ending test code
  
  if (id.isEmpty) {
    return {};
  }
  final gamesList = (await getInfoSteam(id))['games'];
  final futures = <Future<void>>[];
  Map<String, Map<String, dynamic>> games = {};
  Mutex mutex = Mutex();

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
      final bestOptionMatch = _getBestMatch(name, gameOptions);
      if (bestOptionMatch.isNotEmpty) {
        await mutex.protect(() async { // TODO: This might be useless because of the delay given initialy. If we get to that conclusion, then the mutex.protect can be removed
          games[name] = bestOptionMatch;
        });
      }
    }));
  }
  await Future.wait(futures);
  return games;
}

Future<void> confirmImport(Map<String, Map<String, dynamic>> gamesData, LibraryState gamesLibrary) async {
  // TODO: make it so it adds all games in paralel
  for (var gameData in gamesData.entries) {
    await gamesLibrary.addMediaType(gameData.value);
  }
}

Future<void> importSteam(BuildContext context, LibraryState gamesLibrary) {
  TextEditingController controller = TextEditingController();

  Map<String, Map<String, dynamic>> searchResults = {};

  return showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Column(
              children: [
                Text('Import games from Steam library'),
                InkWell(
                  child: Text('How to get Steam ID'),
                  onTap: () async {
                    bool linkOpened = false;
                    try {
                      linkOpened = await launchUrl(Uri.parse('https://www.howtogeek.com/819859/how-to-find-steam-id/#view-your-id-in-the-steam-app'));
                    }
                    catch (e) {
                    }
                    if (!linkOpened) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('The link could not be opened')));
                    }
                  },
                ),
              ],
            ),
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
                          String steamId = controller.text;
                          if (steamId.isNotEmpty) {
                            searchResults = await _getGamesForID(steamId, debugging: false); // TODO: remove debugging here
                            if (context.mounted) {
                              setState(() {});
                            }
                          }
                        },
                      ),
                    ),
                  ),
                  if (searchResults.isNotEmpty) // Confirm button
                    Center(
                      child: TextButton(
                        onPressed: () async {
                          await confirmImport(searchResults, gamesLibrary);
                        },
                        child: Text('Confirm import'),
                      ),
                    ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          for (var entry in searchResults.entries)
                            Card(
                              child: ListTile(
                                title: Text(entry.key),
                              ),
                            ),
                        ],
                      ),
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
