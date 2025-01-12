import 'general/service.dart';
import '../Models/media_user_tag.dart';

class MediaUserTagService extends Service<MediaUserTag> {
  MediaUserTagService._() : super(MediaUserTag.endpoint, MediaUserTag.from);
  
  static final MediaUserTagService _instance = MediaUserTagService._();

  static MediaUserTagService get instance => _instance;
}
