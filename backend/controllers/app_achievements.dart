import '../helpers/routers.dart';
import 'package:shelf_plus/shelf_plus.dart';

RouterPlus appAchievementsRouter() => RouterDefault(
  endpoint          : 'appachievement',
  validateInCreate  : ['name', 'description'],
  populateInCreate  : {'xp': 100},
  dependencyInDelete: false,
).router;
