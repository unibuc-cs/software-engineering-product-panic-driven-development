import '../Models/genre.dart';
import 'general/service.dart';

class GenreService extends Service<Genre> {
  GenreService._() : super(Genre.endpoint, Genre.from);
  
  static final GenreService _instance = GenreService._();

  static GenreService get instance => _instance;
}
