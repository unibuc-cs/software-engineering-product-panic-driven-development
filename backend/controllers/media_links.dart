import '../helpers/routers.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus mediaLinksRouter() => RouterMedia(
  resource: 'link',
).router;
