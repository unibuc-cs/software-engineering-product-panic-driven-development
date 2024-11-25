import 'dart:io';
import 'helpers/config.dart';
import 'providers/manager.dart';
import 'helpers/middleware.dart';
import 'package:shelf/shelf.dart';
import 'helpers/serialization.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

void main() async {
  final router = Router();

  router.get('/', (Request request) {
    final sb = StringBuffer()
      ..write('Available endpoints\n\n')
      ..write('/health\n')
      ..write('/api');

    return Response.ok(sb.toString());
  });

  router.get('/health', (Request request) {
    return Response.ok('Server is healthy!');
  });

  router.get('/api', (Request request) {
    final sb = StringBuffer()
      ..write('Available services\n\n')
      ..write('/igdb\n')
      ..write('/pcgamingwiki\n')
      ..write('/howlongtobeat\n')
      ..write('/goodreads\n')
      ..write('/tmdbmovie\n')
      ..write('/tmdbseries\n')
      ..write('/anilistanime\n')
      ..write('/anilistmanga');

    return Response.ok(sb.toString());
  });

  router.get('/api/<provider>', (Request request) {
    final sb = StringBuffer()
      ..write('Available methods\n\n')
      ..write('/options?name=<query>\n')
      ..write('/info?id=<query>');

    return Response.ok(sb.toString());
  });

  router.get('/api/<provider>/<method>', (Request request, String provider, String method) async {
    final Map<String, String> queryParams = request.url.queryParameters;
    final providerManager = Manager(provider);
    final parameter = method == 'options'
      ? queryParams['name']
      : queryParams['id'];

    if (parameter == null) {
      return Response.badRequest(body: 'Missing parameter for the ${method} method');
    }

    if (method == 'options') {
      final options = await providerManager.getOptions(parameter);
      return listToJson(serializeList(options));
    }
    if (method == 'info') {
      final info = await providerManager.getInfo(parameter);
      return mapToJson(serializeMap(info));
    }
    if (method == 'recommendations') {
      final recommendations = await providerManager.getRecommendations(parameter);
      return listToJson(serializeList(recommendations));
    }

    return Response.notFound('Method not found');
  });

  final handler = const Pipeline()
    .addMiddleware(logger())
    .addMiddleware(unknownEndpoint())
    .addHandler(router);

  final server = await serve(handler, InternetAddress.anyIPv4, Config().port);
  print('Server listening on port ${server.port}');
}
