import 'general/service.dart';
import '../Models/game_achievement.dart';

class GameAchievementService extends Service<GameAchievement> {
  GameAchievementService._() : super(GameAchievement.endpoint, GameAchievement.from);
  
  static final GameAchievementService _instance = GameAchievementService._();

  static GameAchievementService get instance => _instance;
}
