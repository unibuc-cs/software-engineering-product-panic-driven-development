import '../Models/media.dart';
import 'general/service.dart';

class MediaService extends Service<Media> {
  MediaService._() : super(Media.endpoint, Media.from);
  
  static final MediaService _instance = MediaService._();

  static MediaService get instance => _instance;
}
