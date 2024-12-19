import 'general/service.dart';
import '../Models/media_publisher.dart';

class MediaPublisherService extends Service<MediaPublisher> {
  MediaPublisherService() : super(MediaPublisher.endpoint, MediaPublisher.from);
}
