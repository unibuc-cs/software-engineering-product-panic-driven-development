import 'general/service.dart';
import '../Models/user_achievement.dart';

class UserAchievementService extends Service<UserAchievement> {
  UserAchievementService._() : super(UserAchievement.endpoint, UserAchievement.from);
  
  static final UserAchievementService _instance = UserAchievementService._();

  static UserAchievementService get instance => _instance;
}
