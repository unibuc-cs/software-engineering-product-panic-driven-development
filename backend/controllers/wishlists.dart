import '../helpers/routers.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus wishlistsRouter() => RouterDefault(
  endpoint          : 'wishlist',
  requiresUser      : true,
  idField           : 'mediaid',
  validateForTable  : 'media',
  validateInCreate  : ['mediaid', 'name', 'addeddate', 'lastinteracted'],
  populateInCreate  : {'status': 'Plan to Consume'},
  discardInUpdate   : ['mediaid', 'userid'],
  dependencyInDelete: false,
).router;
