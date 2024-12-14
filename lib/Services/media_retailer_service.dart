import '../Models/media_retailer.dart';
import 'general/service_many_to_many.dart';

class MediaRetailerService extends ServiceManyToMany<MediaRetailer> {
  MediaRetailerService()
      : super(
          resource: 'mediaretailers',
          fromJson: (json) => MediaRetailer.from(json),
          toJson  : (mediaRetailer) => mediaRetailer.toSupa(),
        );
}