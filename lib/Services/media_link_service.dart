import '../Models/media_link.dart';
import 'general/service.dart';

class MediaLinkService extends Service<MediaLink> {
  MediaLinkService() : super(
    resource: 'medialinks',
    fromJson: (json) => MediaLink.from(json),
    toJson  : (mediaLink) => mediaLink.toJson(),
  );
}
