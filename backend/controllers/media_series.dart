import '../helpers/routers.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus mediaSeriesRouter() => RouterMedia(
  resource: 'series',
).router;
