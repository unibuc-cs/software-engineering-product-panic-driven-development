import 'dart:core';
import 'generic_test.dart';
import '../../lib/Models/app_achievement.dart';
import '../../lib/Services/app_achievement_service.dart';

void main() async {
  AppAchievement dummyAppAchievement = AppAchievement(
    name: 'Good game',
    description: 'Completed 10 games',
    xp: 10,
  );
  AppAchievement updatedDummyAppAchievement = AppAchievement(
    name: 'Well played',
    description: 'Completed 100 games',
    xp: 15,
  );

  await runService(
    AppAchievementService(),
    dummyAppAchievement,
    updatedDummyAppAchievement,
    (appAchievement) => appAchievement.toSupa()
  );
}
