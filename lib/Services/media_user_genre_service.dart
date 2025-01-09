import 'general/service.dart';
import '../Models/media_user_genre.dart';

class MediaUserGenreService extends Service<MediaUserGenre> {
  MediaUserGenreService() : super(MediaUserGenre.endpoint, MediaUserGenre.from);
}
