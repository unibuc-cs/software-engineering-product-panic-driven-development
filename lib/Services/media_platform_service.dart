import '../Models/media_platform.dart';
import 'general/service.dart';

class MediaPlatformService extends Service<MediaPlatform> {
  MediaPlatformService() : super(
    resource: 'mediaplatforms',
    fromJson: (json) => MediaPlatform.from(json),
    toJson  : (mediaPlatform) => mediaPlatform.toJson(),
  );
}
