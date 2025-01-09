import 'general/service.dart';
import '../Models/game.dart';

class GameService extends Service<Game> {
  GameService() : super(Game.endpoint, Game.from);
}
