import '../Models/app_achievement.dart';
import 'general/service.dart';

class AppAchievementService extends Service<AppAchievement> {
  AppAchievementService() : super(
    resource: 'appachievements',
    fromJson: (json) => AppAchievement.from(json),
    toJson  : (appAchievement) => appAchievement.toJson(),
  );
}
