import '../helpers/routers.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus tagsRouter() => RouterDefault(
  resource          : 'tag',
  dependencyInDelete: false,
).router;
