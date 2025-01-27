import '../helpers/routers.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus retailersRouter() => RouterDefault(
  resource: 'retailer',
).router;
