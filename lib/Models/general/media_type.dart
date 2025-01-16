import '../media.dart';
import '../../Services/media_service.dart';

abstract class MediaType {
  Media get media {
    return MediaService
      .instance
      .items
      .where((media) => media.id == getMediaId())
      .first;
  }

  int getMediaId() {
    throw UnimplementedError('Getter getMediaId was not defined for this type');
  }
}