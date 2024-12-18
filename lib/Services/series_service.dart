import 'general/service.dart';
import '../Models/series.dart';

class SeriesService extends Service<Series> {
  SeriesService() : super(
    resource: 'series',
    fromJson: (json) => Series.from(json),
    toJson  : (series) => series.toSupa(),
  );
}
