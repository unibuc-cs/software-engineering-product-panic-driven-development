import '../Models/media_creator.dart';
import 'general/service.dart';

class MediaCreatorService extends Service<MediaCreator> {
  MediaCreatorService() : super(
    resource: 'mediacreators',
    fromJson: (json) => MediaCreator.from(json),
    toJson  : (mediaCreator) => mediaCreator.toJson(),
  );
}
