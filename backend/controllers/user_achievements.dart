import '../helpers/routers.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus userAchievementsRouter() => RouterDefault(
  endpoint          : 'userachievement',
  requiresUser      : true,
  idField           : 'achievementid',
  validateForTable  : 'appachievement',
  validateInCreate  : ['achievementid', 'unlockdate'],
  discardInUpdate   : ['mediaid', 'userid'],
  dependencyInDelete: false,
).router;
