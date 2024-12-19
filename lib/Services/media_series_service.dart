import '../Models/media_series.dart';
import 'general/service.dart';

class MediaSeriesService extends Service<MediaSeries> {
  MediaSeriesService() : super(
    resource: 'mediaseries',
    fromJson: (json) => MediaSeries.from(json),
    toJson  : (mediaSeries) => mediaSeries.toJson(),
  );
}
