import '../helpers/routers.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus creatorsRouter() => RouterDefault(
  resource: 'creator',
).router;
