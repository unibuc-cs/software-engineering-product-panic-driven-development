import 'link_service.dart';
import 'media_service.dart';
import 'series_service.dart';
import '../Models/manga.dart';
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

class MangaService extends Service<Manga> {
  MangaService._() : super(Manga.endpoint, Manga.from);

  static final MangaService _instance = MangaService._();

  static MangaService get instance => _instance;

  @override
  Future<Manga> create(dynamic model) async {
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
    SeriesService.instance.addToItems(body['series']);
    MediaSeriesService.instance.addToItems(body['mediaseries']);
    MediaService.instance.addToItems(body['related_medias']);
    MangaService.instance.addToItems(body['related_manga']);
    MangaService.instance.addToItems(body);

    return Manga.from(body);
  }
}
