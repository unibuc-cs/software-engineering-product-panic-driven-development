import 'general/service.dart';
import '../Models/game_achievement.dart';

class GameAchievementService extends Service<GameAchievement> {
  GameAchievementService() : super(GameAchievement.endpoint, GameAchievement.from);
}
