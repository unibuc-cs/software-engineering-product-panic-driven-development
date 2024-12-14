import '../Models/media_publisher.dart';
import 'general/service_many_to_many.dart';

class MediaPublisherService extends ServiceManyToMany<MediaPublisher> {
  MediaPublisherService()
      : super(
          resource: 'mediapublishers',
          fromJson: (json) => MediaPublisher.from(json),
          toJson  : (mediaPublisher) => mediaPublisher.toSupa(),
        );
}