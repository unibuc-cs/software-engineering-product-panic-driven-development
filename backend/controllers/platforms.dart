import '../helpers/routers.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus platformsRouter() => RouterDefault(
  resource: 'platform',
).router;
