import '../Models/movie.dart';
import 'general/service.dart';

class MovieService extends Service<Movie> {
  MovieService() : super(Movie.endpoint, Movie.from);
}
