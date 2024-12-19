import '../Models/media.dart';
import 'general/service.dart';

class MediaService extends Service<Media> {
  MediaService() : super(Media.endpoint, Media.from);
}
