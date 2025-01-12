import 'general/service.dart';
import '../Models/media_user_genre.dart';

class MediaUserGenreService extends Service<MediaUserGenre> {
  MediaUserGenreService._() : super(MediaUserGenre.endpoint, MediaUserGenre.from);
  
  static final MediaUserGenreService _instance = MediaUserGenreService._();

  static MediaUserGenreService get instance => _instance;
}
