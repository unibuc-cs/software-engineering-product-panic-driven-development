import 'package:mediamaster/Models/tag.dart';
import 'package:mediamaster/Models/genre.dart';
import 'package:mediamaster/Services/tag_service.dart';
import 'package:mediamaster/Services/genre_service.dart';

Future<void> seedData() async {
  TagService tagServ = TagService.instance;
  GenreService genreServ = GenreService.instance;
  List<Future<void>> allFutures = [];

  if ((await tagServ.readAll()).isEmpty) {
    var tagsToAdd = [
      'Singleplayer',
      'Multiplayer',
      'Casual',
      'Competitive',
      'VR',
      'Indie',
      'Co-Op',
      'Local Co-Op',
      'MMO',
    ];

    allFutures.addAll(tagsToAdd.map((tagName) => tagServ.create(Tag(name: tagName))));
  }

  if ((await genreServ.readAll()).isEmpty) {
    var genresToAdd = [
      'Shooter',
      'Strategy',
      'Role Playing',
      'Survival',
      'Fighting',
      'Horror',
      'Sandbox',
      'Tower Defense',
      'Simulator',
      'Action',
      'Adventure',
      'Party Game',
      'Trivia',
      'Puzzle',
      'Board Game',
      'Sports',
      'Racing',
      'Rhythm',
      'Platformer',
      'Battle Royale',
      'Metroidvania',
      'Roguelike',
      'Soulslike',
      'Idle',
      'Open World',
      'Point and Click',
      'Real Time Strategy',
      'Visual Novel',
      'Superhero',
      'Stealth',
      'Detective',
      'Management',
      'Comedy',
      'Difficult',
      'Cooking',
      'MOBA',
    ];

    allFutures.addAll(genresToAdd.map((genreName) => genreServ.create(Genre(name: genreName))));
  }

  await Future.wait(allFutures);
}

