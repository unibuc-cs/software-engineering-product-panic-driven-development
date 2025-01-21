import '../helpers/routers.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus notesRouter() => RouterDefault(
  resource          : 'note',
  requiresUser      : true,
  idField           : 'id',
  validateInCreate  : ['mediaid', 'content', 'creationdate', 'modifieddate'],
  discardInUpdate   : ['id', 'mediaid', 'userid'],
  dependencyInDelete: false,
).router;
