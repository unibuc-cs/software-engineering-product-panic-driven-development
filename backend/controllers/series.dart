import '../helpers/routers.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus seriesRouter() => RouterDefault(
  resource: 'series',
).router;
