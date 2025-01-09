import '../Models/manga.dart';
import 'general/service.dart';

class MangaService extends Service<Manga> {
  MangaService() : super(Manga.endpoint, Manga.from);
}
