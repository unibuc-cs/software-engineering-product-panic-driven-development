import 'package:mediamaster/Services/genre_service.dart';
import 'package:mediamaster/Services/media_genre_service.dart';

import 'link_service.dart';
import 'media_service.dart';
import 'series_service.dart';
import '../Models/game.dart';
import 'general/service.dart';
import 'creator_service.dart';
import 'platform_service.dart';
import 'retailer_service.dart';
import 'publisher_service.dart';
import 'media_link_service.dart';
import 'media_series_service.dart';
import 'media_creator_service.dart';
import 'media_platform_service.dart';
import 'media_retailer_service.dart';
import 'media_publisher_service.dart';

class GameService extends Service<Game> {
  GameService._() : super(Game.endpoint, Game.from);

  static final GameService _instance = GameService._();

  static GameService get instance => _instance;

  @override
  Future<Game> create(dynamic model) async {
    final body = await makePostRequest(model);

    MediaService.instance.addToItems(body['media']);
    CreatorService.instance.addToItems(body['creators']);
    MediaCreatorService.instance.addToItems(body['mediacreators']);
    PublisherService.instance.addToItems(body['publishers']);
    MediaPublisherService.instance.addToItems(body['mediapublishers']);
    PlatformService.instance.addToItems(body['platforms']);
    MediaPlatformService.instance.addToItems(body['mediaplatforms']);
    LinkService.instance.addToItems(body['links']);
    MediaLinkService.instance.addToItems(body['medialinks']);
    RetailerService.instance.addToItems(body['retailers']);
    MediaRetailerService.instance.addToItems(body['mediaretailers']);
    GenreService.instance.addToItems(body['genres']);
    MediaGenreService.instance.addToItems(body['mediagenres']);
    SeriesService.instance.addToItems(body['series']);
    MediaSeriesService.instance.addToItems(body['mediaseries']);
    MediaService.instance.addToItems(body['related_medias']);
    GameService.instance.addToItems(body['related_games']);
    GameService.instance.addToItems(body);

    return Game.from(body);
  }
}
