import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'manager.dart';
import 'package:dart_console/dart_console.dart';

final console = Console();
final options = {
  '1': 'igdb',
  '2': 'pcgamingwiki',
  '3': 'howlongtobeat',
  '4': 'goodreads',
  '5': 'tmdbmovies',
  '6': 'tmdbseries',
  '7': 'anilistanime',
  '8': 'anilistmanga',
};

String encodeWithDateTime(Map<String, dynamic> data) => const JsonEncoder
  .withIndent('  ')
  .convert(data.map((key, value) =>
    value is DateTime
      ? MapEntry(key, value.toString().substring(0, 10))
      : MapEntry(key, value);
  ));

int getUserInput(List<Map<String, dynamic>> options) {
  try {
    console.clearScreen();
    print('Choose an option:');
    for (int i = 0; i < options.length; ++i) {
      print('[${i + 1}] ${options[i]['name']}');
    }
    stdout.write('\nEnter the number of the game: ');
    final choice = stdin.readLineSync();
    console.clearScreen();

    if (choice != null) {
      final index = int.parse(choice);
      if (index > 0 && index <= options.length) {
        return index;
      } else {
        return 0;
      }
    } else {
      return 0;
    }
  } catch (e) {
    return 0;
  }
}

Future<void> main() async {
  console.clearScreen();
  String query = 'Hollow Knight';
  bool running = true;
  while (running) {
    print('Choose an option:');
    print('[1] IGDB (Games)');
    print('[2] PcGamingWiki (Game System Requirements)');
    print('[3] HowLongToBeat (Game Times)');
    print('[4] Goodreads (Books)');
    print('[5] TMDB (Movies)');
    print('[6] TMDB (TV Series)');
    print('[7] Anilist (Anime)');
    print('[8] Anilist (Manga)');
    print('[9] Change query (Current: $query)');
    print('[0] Exit');
    stdout.write('\nEnter your choice: ');
    var choice = stdin.readLineSync() ?? '';
    console.clearScreen();
    String providerName = 'igdb';
    switch (choice) {
      case '9':
        stdout.write('New query: ');
        query = stdin.readLineSync() ?? '';
        break;
      case '0':
        running = false;
        break;
      default:
        providerName = options[choice] ?? 'igdb';
    }

    final providerManager = Manager(providerName);
    if (running && choice != '9') {
      final options = await providerManager.getOptions(query);
      final index = getUserInput(options);
      if (index != 0) {
        final choice = options[index - 1];
        final id = choice[providerManager.getProvider()?.getKey() ?? ''].toString();
        final answer = await providerManager.getInfo(id);
        print(choice['name']);
        print(encodeWithDateTime(answer));
      }
      stdout.write('\nPress Enter to continue...');
      stdin.readLineSync();
    }
    console.clearScreen();
  }
}
