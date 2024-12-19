import '../Models/media.dart';
import 'general/service.dart';

class MediaService extends Service<Media> {
  MediaService() : super(
    resource: 'medias',
    fromJson: (json) => Media.from(json),
    toJson  : (media) => media.toJson(),
  );
}
