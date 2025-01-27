import '../helpers/routers.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus seasonsRouter() => RouterDefault(
  resource          : 'season',
  dependencyInDelete: false,
).router;
