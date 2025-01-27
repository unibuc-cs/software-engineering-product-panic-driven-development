import '../helpers/routers.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus wishlistsRouter() => RouterDefault(
  resource          : 'wishlist',
  requiresUser      : true,
  idField           : 'mediaid',
  validateForTable  : 'media',
  validateInCreate  : ['mediaid', 'name', 'addeddate', 'lastinteracted'],
  discardInUpdate   : ['mediaid', 'userid'],
  dependencyInDelete: false,
).router;
