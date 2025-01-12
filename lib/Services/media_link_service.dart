import 'general/service.dart';
import '../Models/media_link.dart';

class MediaLinkService extends Service<MediaLink> {
  MediaLinkService._() : super(MediaLink.endpoint, MediaLink.from);
  
  static final MediaLinkService _instance = MediaLinkService._();

  static MediaLinkService get instance => _instance;
}
