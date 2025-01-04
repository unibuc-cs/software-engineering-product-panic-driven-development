import 'auth.dart';
import 'tags.dart';
import 'books.dart';
import 'links.dart';
import 'genres.dart';
import 'medias.dart';
import 'series.dart';
import 'creators.dart';
import 'platforms.dart';
import 'retailers.dart';
import 'publishers.dart';
import 'media_links.dart';
import 'media_series.dart';
import 'media_creators.dart';
import 'media_retailers.dart';
import 'media_platforms.dart';
import 'app_achievements.dart';
import 'media_publishers.dart';
import '../helpers/utils.dart';
import '../services/manager.dart';
import '../helpers/responses.dart';
import '../helpers/middleware.dart';
import '../helpers/validators.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus apiRouter() {
  final router = Router(notFoundHandler: unknownEndpoint).plus;

  router.mount('/auth', authRouter().call);
  router.mount('/tags', tagsRouter().call);
  router.mount('/books', booksRouter().call);
  router.mount('/links', linksRouter().call);
  router.mount('/genres', requireAuth(genresRouter().call));
  router.mount('/medias', mediasRouter().call);
  router.mount('/series', seriesRouter().call);
  router.mount('/creators', creatorsRouter().call);
  router.mount('/platforms', platformsRouter().call);
  router.mount('/retailers', retailersRouter().call);
  router.mount('/publishers', publishersRouter().call);
  router.mount('/medialinks', mediaLinksRouter().call);
  router.mount('/mediaseries', mediaSeriesRouter().call);
  router.mount('/mediacreators', mediaCreatorsRouter().call);
  router.mount('/mediaplatforms', mediaPlatformsRouter().call);
  router.mount('/mediaretailers', mediaRetailersRouter().call);
  router.mount('/mediapublishers', mediaPublishersRouter().call);
  router.mount('/appachievements', appAchievementsRouter().call);

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