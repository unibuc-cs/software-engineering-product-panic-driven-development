import 'dart:io';
import 'helpers/utils.dart';
import 'helpers/config.dart';
import 'controllers/api.dart';
import 'helpers/middleware.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_hotreload/shelf_hotreload.dart';

Future<HttpServer> createServer() async {
  final router = Router();

  router.mount('/api', apiRouter().call);

  final handler = const Pipeline()
      .addMiddleware(logger())
      .addMiddleware(errorHandling())
      .addMiddleware(unknownEndpoint())
      .addHandler(router);

  final server = await serve(
    handler,
    InternetAddress.anyIPv4,
    Config().port
  );
  print('Server listening on port ${server.port}');
  return server;
}

void main() async {
  withHotreload(() => createServer());
}
