import 'general/service.dart';
import '../Models/media_link.dart';

class MediaLinkService extends Service<MediaLink> {
  MediaLinkService() : super(MediaLink.endpoint, MediaLink.from);
}
