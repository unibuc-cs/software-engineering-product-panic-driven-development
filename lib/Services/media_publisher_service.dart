import 'general/service.dart';
import '../Models/media_publisher.dart';

class MediaPublisherService extends Service<MediaPublisher> {
  MediaPublisherService._() : super(MediaPublisher.endpoint, MediaPublisher.from);
  
  static final MediaPublisherService _instance = MediaPublisherService._();

  static MediaPublisherService get instance => _instance;
}
