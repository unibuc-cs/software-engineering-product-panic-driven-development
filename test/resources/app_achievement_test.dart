import 'dart:core';
import 'generic_test.dart';
import '../../lib/Models/app_achievement.dart';
import '../../lib/Services/app_achievement_service.dart';

void main() async {
  AppAchievement dummy = AppAchievement(
    name: 'Good game',
    description: 'Completed 10 games',
    xp: 10,
  );
  AppAchievement updated = AppAchievement(
    name: 'Well played',
    description: 'Completed 100 games',
    xp: 15,
  );

  await runService(
    service    : AppAchievementService(),
    dummyItem  : dummy,
    updatedItem: updated,
    toJson     : (appAchievement) => appAchievement.toJson(),
  );
}
