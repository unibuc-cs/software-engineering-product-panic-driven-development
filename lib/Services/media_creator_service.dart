import 'general/service.dart';
import '../Models/media_creator.dart';

class MediaCreatorService extends Service<MediaCreator> {
  MediaCreatorService._() : super(MediaCreator.endpoint, MediaCreator.from);
  
  static final MediaCreatorService _instance = MediaCreatorService._();

  static MediaCreatorService get instance => _instance;
}
