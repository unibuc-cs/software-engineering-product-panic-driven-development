import 'general/service.dart';
import '../Models/app_achievement.dart';

class AppAchievementService extends Service<AppAchievement> {
  AppAchievementService() : super(AppAchievement.endpoint, AppAchievement.from);
}
