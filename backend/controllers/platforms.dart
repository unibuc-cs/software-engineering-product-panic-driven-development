import '../helpers/routers.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus platformsRouter() => RouterDefault(
  endpoint: 'platform',
).router;
