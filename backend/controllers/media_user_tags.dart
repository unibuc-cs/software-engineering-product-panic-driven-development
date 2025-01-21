import '../helpers/routers.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus mediaUserTagsRouter() => RouterMedia(
  resource    : 'tag',
  requiresUser: true,
).router;
