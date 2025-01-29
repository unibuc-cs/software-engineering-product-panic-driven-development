import 'helpers/io.dart';
import 'helpers/config.dart';
import 'controllers/api.dart';
import 'helpers/requests.dart';
import 'helpers/responses.dart';
import 'helpers/middleware.dart';
import 'package:shelf_plus/shelf_plus.dart';

Future<Handler> init() async {
  await seedData();
  var app = Router(notFoundHandler: unknownEndpoint).plus;
  app.mount('/api', extractUserId(logger(errorHandling(apiRouter()))));
  app.get('/favicon.ico', faviconNotFound);
  return app.call;
}

Future<ShelfRunContext> main() async => shelfRun(
  await init,
  defaultBindPort       : Config.instance.port,
  defaultBindAddress    : bool.fromEnvironment('LOCAL', defaultValue: false) ? 'localhost' : '0.0.0.0',
  defaultEnableHotReload: bool.fromEnvironment('RELOAD', defaultValue: false),
  onStarted             : startupLog
);
