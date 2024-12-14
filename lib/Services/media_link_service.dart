import '../Models/media_link.dart';
import 'general/service_many_to_many.dart';

class MediaLinkService extends ServiceManyToMany<MediaLink> {
  MediaLinkService()
      : super(
          resource: 'medialinks',
          fromJson: (json) => MediaLink.from(json),
          toJson  : (mediaLink) => mediaLink.toSupa(),
        );
}