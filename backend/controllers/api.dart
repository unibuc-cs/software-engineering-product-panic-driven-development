import 'links.dart';
import 'publishers.dart';
import '../helpers/utils.dart';
import '../services/manager.dart';
import '../helpers/responses.dart';
import '../helpers/validators.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus apiRouter() {
  final router = Router().plus;

  router.mount('/links', linksRouter());
  router.mount('/publishers', publishersRouter());

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