import '../Models/media_series.dart';
import 'general/service_many_to_many.dart';

class MediaSeriesService extends ServiceManyToMany<MediaSeries> {
  MediaSeriesService()
      : super(
          resource: 'mediaseries',
          fromJson: (json) => MediaSeries.from(json),
          toJson  : (mediaSeries) => mediaSeries.toSupa(),
        );
}