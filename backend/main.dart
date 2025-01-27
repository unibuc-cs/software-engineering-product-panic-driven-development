import 'helpers/io.dart';
import 'helpers/config.dart';
import 'controllers/api.dart';
import 'helpers/responses.dart';
import 'helpers/middleware.dart';
import 'package:shelf_plus/shelf_plus.dart';

Handler init() {
  var app = Router(notFoundHandler: unknownEndpoint).plus;
  app.mount('/api', extractUserId(logger(errorHandling(apiRouter()))));
  app.get('/favicon.ico', faviconNotFound);
  return app.call;
}

void main() => shelfRun(
  init,
  defaultBindPort       : Config.instance.port,
  defaultBindAddress    : bool.fromEnvironment('LOCAL', defaultValue: false) ? 'localhost' : '0.0.0.0',
  defaultEnableHotReload: bool.fromEnvironment('RELOAD', defaultValue: false),
  onStarted             : startupLog
);
