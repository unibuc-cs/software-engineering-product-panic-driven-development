import 'general/service.dart';
import '../Models/app_achievement.dart';

class AppAchievementService extends Service<AppAchievement> {
  AppAchievementService._() : super(AppAchievement.endpoint, AppAchievement.from);
  
  static final AppAchievementService _instance = AppAchievementService._();

  static AppAchievementService get instance => _instance;
}
