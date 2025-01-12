import 'general/service.dart';
import '../Models/media_retailer.dart';

class MediaRetailerService extends Service<MediaRetailer> {
  MediaRetailerService._() : super(MediaRetailer.endpoint, MediaRetailer.from);
  
  static final MediaRetailerService _instance = MediaRetailerService._();

  static MediaRetailerService get instance => _instance;
}
