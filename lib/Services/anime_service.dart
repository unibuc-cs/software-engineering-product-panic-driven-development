import '../Models/anime.dart';
import 'general/service.dart';

class AnimeService extends Service<Anime> {
  AnimeService() : super(Anime.endpoint, Anime.from);
}
