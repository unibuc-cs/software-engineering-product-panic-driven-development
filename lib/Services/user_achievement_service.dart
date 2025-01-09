import 'general/service.dart';
import '../Models/user_achievement.dart';

class UserAchievementService extends Service<UserAchievement> {
  UserAchievementService() : super(UserAchievement.endpoint, UserAchievement.from);
}
