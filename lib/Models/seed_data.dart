import 'tag.dart';
import 'genre.dart';
import '../Services/tag_service.dart';
import '../Services/genre_service.dart';

Future<void> addSeedData() async {
  TagService tagServ = TagService();
  GenreService genreServ = GenreService();
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

