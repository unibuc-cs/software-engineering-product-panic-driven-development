import 'general/service.dart';
import '../Models/media_retailer.dart';

class MediaRetailerService extends Service<MediaRetailer> {
  MediaRetailerService() : super(MediaRetailer.endpoint, MediaRetailer.from);
}
