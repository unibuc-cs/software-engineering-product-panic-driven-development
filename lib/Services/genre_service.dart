import '../Models/genre.dart';
import 'general/service.dart';

class GenreService extends Service<Genre> {
  GenreService() : super(
    resource: 'genres',
    fromJson: (json) => Genre.from(json),
    toJson  : (genre) => genre.toJson(),
  );
}
