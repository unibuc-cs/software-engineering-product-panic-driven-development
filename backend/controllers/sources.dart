import '../helpers/routers.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus sourcesRouter() => RouterDefault(
  resource      : 'source',
  userDependency: true,
).router;
