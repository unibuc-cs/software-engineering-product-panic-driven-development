import '../helpers/routers.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus mediaUserSourcesRouter() => RouterMedia(
  resource    : 'source',
  requiresUser: true,
).router;
