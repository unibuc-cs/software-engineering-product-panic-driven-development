import '../Models/media_platform.dart';
import 'general/service_many_to_many.dart';

class MediaPlatformService extends ServiceManyToMany<MediaPlatform> {
  MediaPlatformService()
      : super(
          resource: 'mediaplatforms',
          fromJson: (json) => MediaPlatform.from(json),
          toJson  : (mediaPlatform) => mediaPlatform.toSupa(),
        );
}