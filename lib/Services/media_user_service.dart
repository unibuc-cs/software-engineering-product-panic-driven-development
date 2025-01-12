import 'general/service.dart';
import '../Models/media_user.dart';

class MediaUserService extends Service<MediaUser> {
  MediaUserService._() : super(MediaUser.endpoint, MediaUser.from);
  
  static final MediaUserService _instance = MediaUserService._();

  static MediaUserService get instance => _instance;
}
