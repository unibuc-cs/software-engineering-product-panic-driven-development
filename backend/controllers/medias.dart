import '../helpers/routers.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus mediasRouter() => RouterDefault(
  endpoint        : 'media',
  nameField       : 'originalName',
  validateInCreate: [],
  discardInUpdate : ['id', 'mediatype'],
  noDelete        : true,
).router;
