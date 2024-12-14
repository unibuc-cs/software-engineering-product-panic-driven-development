import '../Models/media_creator.dart';
import 'general/service_many_to_many.dart';

class MediaCreatorService extends ServiceManyToMany<MediaCreator> {
  MediaCreatorService()
      : super(
          resource: 'mediacreators',
          fromJson: (json) => MediaCreator.from(json),
          toJson  : (mediaCreator) => mediaCreator.toSupa(),
        );
}