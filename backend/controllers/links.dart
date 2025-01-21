import '../helpers/routers.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus linksRouter() => RouterDefault(
  resource        : 'link',
  nameField       : 'href',
  validateInCreate: ['name', 'href'],
  discardInUpdate : ['id', 'mediatype'],
).router;
