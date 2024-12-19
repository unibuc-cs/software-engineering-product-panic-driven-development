import 'general/service.dart';
import '../Models/media_creator.dart';

class MediaCreatorService extends Service<MediaCreator> {
  MediaCreatorService() : super('mediacreators', MediaCreator.from);
}
