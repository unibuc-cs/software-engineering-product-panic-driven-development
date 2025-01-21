import '../helpers/routers.dart';
import 'package:shelf_plus/shelf_plus.dart';

final discardInCreate = [
  'id',
  'url',
  'artworks',
  'coverimage',
  'icon',
  'status',
  'episodes', // this is temporary, just for testing
  'duration',
];

RouterPlus animeRouter() => RouterDefault(
  resource        : 'anime',
  isMediaType     : true,
  nameField       : 'mediaid',
  discardInCreate : discardInCreate,
  validateInCreate: [],
  discardInUpdate : ['id', 'mediaid'],
  noDelete        : true,
).router;
