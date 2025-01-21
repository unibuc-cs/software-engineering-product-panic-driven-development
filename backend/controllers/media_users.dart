import '../helpers/routers.dart';
import 'package:shelf_plus/shelf_plus.dart';

final populateInCreate = {
  'status': 'Plan to Consume',
  'gametime': 0,
  'bookreadpages': 0,
  'nrepisodesseen': 0,
};

RouterPlus mediaUsersRouter() => RouterDefault(
  resource          : 'mediauser',
  requiresUser      : true,
  idField           : 'mediaid',
  validateForTable  : 'media',
  validateInCreate  : ['mediaid', 'name', 'addeddate', 'lastinteracted'],
  populateInCreate  : populateInCreate,
  discardInUpdate   : ['mediaid', 'userid'],
  dependencyInDelete: false,
).router;
