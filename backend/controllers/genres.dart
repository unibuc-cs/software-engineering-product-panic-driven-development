import '../helpers/routers.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus genresRouter() => RouterDefault(
  resource          : 'genre',
  dependencyInDelete: false,
).router;
