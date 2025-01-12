import 'dart:core';
import '../general/resource_test.dart';
import 'package:mediamaster/Models/user_achievement.dart';
import 'package:mediamaster/Services/app_achievement_service.dart';
import 'package:mediamaster/Services/user_achievement_service.dart';

void main() async {
  Map<String, dynamic> achievement = {
    'name': 'test',
    'description': 'test',
    'xp': 10,
  };
  UserAchievement dummy = UserAchievement(
    userId: '',
    achievementId: await getValidId(
      service: AppAchievementService.instance,
      backup : achievement
    ),
    unlockDate: DateTime.now(),
  );

  UserAchievement updatedDummy = UserAchievement(
    userId: '',
    achievementId: await getValidId(
      service: AppAchievementService.instance,
      backup : achievement
    ),
    unlockDate: DateTime.now(),
  );

  await runService(
    service    : UserAchievementService.instance,
    dummyItem  : dummy,
    updatedItem: updatedDummy,
    tables     : ['achievement'],
    authNeeded : true,
  );
}
