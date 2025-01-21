import '../helpers/routers.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus mediaGenresRouter() => RouterMedia(
  resource: 'genre',
).router;
