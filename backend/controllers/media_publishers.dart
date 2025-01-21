import '../helpers/routers.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus mediaPublishersRouter() => RouterMedia(
  resource: 'publisher',
).router;
