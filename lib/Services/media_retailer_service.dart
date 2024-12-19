import '../Models/media_retailer.dart';
import 'general/service.dart';

class MediaRetailerService extends Service<MediaRetailer> {
  MediaRetailerService() : super(
    resource: 'mediaretailers',
    fromJson: (json) => MediaRetailer.from(json),
    toJson  : (mediaRetailer) => mediaRetailer.toJson(),
  );
}
