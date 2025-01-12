import 'general/service.dart';
import '../Models/media_series.dart';

class MediaSeriesService extends Service<MediaSeries> {
  MediaSeriesService._() : super(MediaSeries.endpoint, MediaSeries.from);
  
  static final MediaSeriesService _instance = MediaSeriesService._();

  static MediaSeriesService get instance => _instance;
}
