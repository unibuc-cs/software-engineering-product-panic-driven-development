import '../helpers/routers.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus mediaPlatformsRouter() => RouterMedia(
  resource: 'platform',
).router;
