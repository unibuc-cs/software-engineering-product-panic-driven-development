import 'general/service.dart';
import '../Models/media_series.dart';

class MediaSeriesService extends Service<MediaSeries> {
  MediaSeriesService() : super(MediaSeries.endpoint, MediaSeries.from);
}
