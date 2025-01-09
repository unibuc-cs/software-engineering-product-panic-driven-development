import '../Models/genre.dart';
import 'general/service.dart';

class GenreService extends Service<Genre> {
  GenreService() : super(Genre.endpoint, Genre.from);
}
