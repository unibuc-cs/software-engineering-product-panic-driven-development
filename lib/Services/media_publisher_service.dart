import '../Models/media_publisher.dart';
import 'general/service.dart';

class MediaPublisherService extends Service<MediaPublisher> {
  MediaPublisherService() : super(
    resource: 'mediapublishers',
    fromJson: (json) => MediaPublisher.from(json),
    toJson  : (mediaPublisher) => mediaPublisher.toJson(),
  );
}
