import '../helpers/routers.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus publishersRouter() => RouterDefault(
  endpoint: 'publisher',
).router;
