import '../helpers/routers.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus mediasRouter() => RouterDefault(
  resource        : 'media',
  nameField       : 'originalname',
  validateInCreate: [],
  discardInUpdate : ['id', 'mediatype'],
  noDelete        : true,
).router;
