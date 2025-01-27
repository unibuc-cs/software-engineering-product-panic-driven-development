import '../helpers/routers.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus gameAchievementsRouter() => RouterDefault(
  resource          : 'gameachievement',
  validateInCreate  : ['gameid', 'name', 'description'],
  discardInUpdate   : ['id', 'gameid'],
  dependencyInDelete: false,
).router;
