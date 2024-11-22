import 'dart:io';
import 'helpers/middleware.dart';
import 'package:shelf/shelf.dart';
import 'helpers/serialization.dart';
import 'package:shelf/shelf_io.dart';
import 'services/general/servicemanager.dart';
import 'package:shelf_router/shelf_router.dart';

void main() async {
  final router = Router();

  router.get('/', (Request request) {
    return Response.ok('Backend server is running! Available endpoints: /health, /api, /api/hollow');
  });

  router.get('/health', (Request request) {
    return Response.ok('Server is healthy!');
  });

  router.get('/api', (Request request) {
    return Response.ok('API is not implemented yet');
  });

  router.get('/api/hollow', (Request request) async {
    final manager = ServiceManager("igdb");
    final options = await manager.getOptions("Hollow Knight");
    final choice = options[0];
    final answer = await manager.getInfo(choice[manager.getService()?.getKey() ?? ""].toString());
    return jsonResponse(serialize(answer));
  });

  final handler = const Pipeline()
    .addMiddleware(logger())
    .addMiddleware(unknownEndpoint())
    .addHandler(router);

  final server = await serve(handler, InternetAddress.anyIPv4, 8080);
  print('Server listening on port ${server.port}');
}
