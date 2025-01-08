import 'general/service.dart';
import '../Models/media_user.dart';

class MediaUserService extends Service<MediaUser> {
  MediaUserService() : super(MediaUser.endpoint, MediaUser.from);
}
