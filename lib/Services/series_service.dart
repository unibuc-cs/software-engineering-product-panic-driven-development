import 'general/service.dart';
import '../Models/series.dart';

class SeriesService extends Service<Series> {
  SeriesService() : super(Series.endpoint, Series.from);
}
