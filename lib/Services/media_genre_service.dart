import 'general/service.dart';
import '../Models/media_genre.dart';

class MediaGenreService extends Service<MediaGenre> {
  MediaGenreService._() : super(MediaGenre.endpoint, MediaGenre.from);
  
  static final MediaGenreService _instance = MediaGenreService._();

  static MediaGenreService get instance => _instance;
}
