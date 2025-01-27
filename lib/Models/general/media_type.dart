import '../media.dart';
import '../../Services/media_service.dart';

abstract class MediaType {
  Media? _media = null;

  Media get media {
    if (_media == null) {
      _media = MediaService
        .instance
        .items
        .where((media) => media.id == getMediaId())
        .first;
    }
    return _media!;
  }

  int getMediaId() {
    throw UnimplementedError('Getter getMediaId was not defined for this type');
  }
}