import 'general/service.dart';
import '../Models/media_platform.dart';

class MediaPlatformService extends Service<MediaPlatform> {
  MediaPlatformService() : super(MediaPlatform.endpoint, MediaPlatform.from);
}
