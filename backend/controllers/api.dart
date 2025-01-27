import 'auth.dart';
import 'notes.dart';
import 'anime.dart';
import 'books.dart';
import 'games.dart';
import 'links.dart';
import 'manga.dart';
import 'genres.dart';
import 'medias.dart';
import 'movies.dart';
import 'series.dart';
import 'seasons.dart';
import 'creators.dart';
import 'platforms.dart';
import 'retailers.dart';
import 'tv_series.dart';
import 'user_tags.dart';
import 'wishlists.dart';
import 'media_users.dart';
import 'publishers.dart';
import 'media_links.dart';
import 'media_series.dart';
import 'media_creators.dart';
import 'media_user_tags.dart';
import 'media_retailers.dart';
import 'media_platforms.dart';
import 'media_genres.dart';
import 'app_achievements.dart';
import 'media_publishers.dart';
import '../helpers/utils.dart';
import 'game_achievements.dart';
import 'user_achievements.dart';
import '../services/manager.dart';
import '../helpers/responses.dart';
import '../helpers/middleware.dart';
import '../helpers/validators.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus apiRouter() {
  final router = Router(notFoundHandler: unknownEndpoint).plus;

  router.mount('/auth', authRouter().call);
  router.mount('/anime', animeRouter().call);
  router.mount('/books', booksRouter().call);
  router.mount('/games', gamesRouter().call);
  router.mount('/links', linksRouter().call);
  router.mount('/manga', mangaRouter().call);
  router.mount('/genres', genresRouter().call);
  router.mount('/medias', mediasRouter().call);
  router.mount('/movies', moviesRouter().call);
  router.mount('/series', seriesRouter().call);
  router.mount('/seasons', seasonsRouter().call);
  router.mount('/creators', creatorsRouter().call);
  router.mount('/tvseries', TVSeriesRouter().call);
  router.mount('/platforms', platformsRouter().call);
  router.mount('/retailers', retailersRouter().call);
  router.mount('/publishers', publishersRouter().call);
  router.mount('/medialinks', mediaLinksRouter().call);
  router.mount('/mediagenres', mediaGenresRouter().call);
  router.mount('/mediaseries', mediaSeriesRouter().call);
  router.mount('/notes', requireAuth(notesRouter().call));
  router.mount('/mediacreators', mediaCreatorsRouter().call);
  router.mount('/mediaplatforms', mediaPlatformsRouter().call);
  router.mount('/mediaretailers', mediaRetailersRouter().call);
  router.mount('/usertags', requireAuth(userTagsRouter().call));
  router.mount('/mediapublishers', mediaPublishersRouter().call);
  router.mount('/appachievements', appAchievementsRouter().call);
  router.mount('/wishlists', requireAuth(wishlistsRouter().call));
  router.mount('/gameachievements', gameAchievementsRouter().call);
  router.mount('/mediausers', requireAuth(mediaUsersRouter().call));
  router.mount('/mediausertags', requireAuth(mediaUserTagsRouter().call));
  router.mount('/userachievements', requireAuth(userAchievementsRouter().call));

  router.get('/health', (Request request) {
    return sendOk('Server is healthy!');
  });

  router.get('/<service>/<method>', (Request request, String service, String method) async {
    validateService(service);
    validateMethod(method);
    final Map<String, String> queryParams = request.url.queryParameters;
    final serviceManager = Manager(service);
    final parameter = method == 'options'
      ? queryParams['name']
      : queryParams['id'];

    if (parameter == null) {
      return sendBadRequest('Missing parameter for the $method method');
    }

    if (method == 'options') {
      final options = await serviceManager.getOptions(parameter);
      if (options.length == 1 && options[0].containsKey('error')) {
        return handleServiceErrors(options[0]['error']);
      }
      return sendOk(serialize(options));
    }
    if (method == 'info') {
      final info = await serviceManager.getInfo(parameter);
      if (info.containsKey('error')) {
        return handleServiceErrors(info['error']);
      }
      return sendOk(serialize(info));
    }
    if (method == 'recommendations') {
      final recommendations = await serviceManager.getRecommendations(parameter);
      if (recommendations.length == 1 && recommendations[0].containsKey('error')) {
        return handleServiceErrors(recommendations[0]['error']);
      }
      return sendOk(serialize(recommendations));
    }
    return sendNotFound('Method not found');
  });

  return router;
}