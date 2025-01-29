import '../helpers/routers.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus userTagsRouter() => RouterDefault(
  resource      : 'usertag',
  requiresUser  : true,
).router;
