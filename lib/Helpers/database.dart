import '../Models/tag.dart';
import '../Models/genre.dart';
import '../Services/anime_service.dart';
import '../Services/app_achievement_service.dart';
import '../Services/book_service.dart';
import '../Services/creator_service.dart';
import '../Services/game_achievement_service.dart';
import '../Services/game_service.dart';
import '../Services/general/service.dart';
import '../Services/link_service.dart';
import '../Services/manga_service.dart';
import '../Services/media_creator_service.dart';
import '../Services/media_link_service.dart';
import '../Services/media_platform_service.dart';
import '../Services/media_publisher_service.dart';
import '../Services/media_retailer_service.dart';
import '../Services/media_series_service.dart';
import '../Services/media_service.dart';
import '../Services/media_genre_service.dart';
import '../Services/media_user_service.dart';
import '../Services/media_user_tag_service.dart';
import '../Services/movie_service.dart';
import '../Services/note_service.dart';
import '../Services/platform_service.dart';
import '../Services/publisher_service.dart';
import '../Services/retailer_service.dart';
import '../Services/season_service.dart';
import '../Services/series_service.dart';
import '../Services/tag_service.dart';
import '../Services/genre_service.dart';
import '../Services/tv_series_service.dart';
import '../Services/user_achievement_service.dart';
import '../Services/wishlist_service.dart';

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

Future<void> HydrateWithoutUser() async {
  List<Service> services = [
    AnimeService.instance,
    AppAchievementService.instance,
    BookService.instance,
    CreatorService.instance,
    GameService.instance,
    GameAchievementService.instance,
    GenreService.instance,
    LinkService.instance,
    MangaService.instance,
    MediaService.instance,
    MediaCreatorService.instance,
    MediaGenreService.instance,
    MediaLinkService.instance,
    MediaPlatformService.instance,
    MediaPublisherService.instance,
    MediaRetailerService.instance,
    MediaSeriesService.instance,
    MovieService.instance,
    PlatformService.instance,
    PublisherService.instance,
    RetailerService.instance,
    SeasonService.instance,
    SeriesService.instance,
    TagService.instance,
    TVSeriesService.instance,
  ];

  await Future.wait(services.map((service) => service.hydrate()).toList());
}

Future<void> HydrateWithUser() async {
  List<Service> services = [
    MediaUserService.instance,
    MediaUserTagService.instance,
    NoteService.instance,
    UserAchievementService.instance,
    WishlistService.instance,
  ];

  await Future.wait(services.map((service) => service.hydrate()).toList());
}

void UnhydrateWithUser() {
  List<Service> services = [
    MediaUserService.instance,
    MediaUserTagService.instance,
    NoteService.instance,
    UserAchievementService.instance,
    WishlistService.instance,
  ];

  for (dynamic service in services) {
    service.unhydrate();
  }
}
