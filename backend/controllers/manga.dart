import '../helpers/routers.dart';
import 'package:shelf_plus/shelf_plus.dart';

final discardInCreate = [
  'id',
  'url',
  'artworks',
  'coverimage',
  'icon',
  'status',
  'nrvolumes',
];

RouterPlus mangaRouter() => RouterDefault(
  resource        : 'manga',
  isMediaType     : true,
  nameField       : 'mediaid',
  discardInCreate : discardInCreate,
  validateInCreate: [],
  discardInUpdate : ['id', 'mediaid'],
  noDelete        : true,
).router;
