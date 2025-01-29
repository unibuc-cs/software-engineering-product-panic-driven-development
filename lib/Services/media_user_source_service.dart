import 'general/service.dart';
import '../Models/media_user_source.dart';

class MediaUserSourceService extends Service<MediaUserSource> {
  MediaUserSourceService._() : super(MediaUserSource.endpoint, MediaUserSource.from);
  
  static final MediaUserSourceService _instance = MediaUserSourceService._();

  static MediaUserSourceService get instance => _instance;
}
