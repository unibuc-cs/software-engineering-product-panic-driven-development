import '../helpers/routers.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus seasonsRouter() => RouterDefault(
  endpoint          : 'season',
  dependencyInDelete: false,
).router;
