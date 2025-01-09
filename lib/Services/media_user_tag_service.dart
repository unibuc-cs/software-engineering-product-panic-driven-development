import 'general/service.dart';
import '../Models/media_user_tag.dart';

class MediaUserTagService extends Service<MediaUserTag> {
  MediaUserTagService() : super(MediaUserTag.endpoint, MediaUserTag.from);
}
