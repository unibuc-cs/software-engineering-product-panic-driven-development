import 'general/service.dart';
import '../Models/media_platform.dart';

class MediaPlatformService extends Service<MediaPlatform> {
  MediaPlatformService._() : super(MediaPlatform.endpoint, MediaPlatform.from);
  
  static final MediaPlatformService _instance = MediaPlatformService._();

  static MediaPlatformService get instance => _instance;
}
