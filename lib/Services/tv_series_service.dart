import '../Models/tv_series.dart';
import 'general/service.dart';

class TVSeriesService extends Service<TVSeries> {
  TVSeriesService() : super(TVSeries.endpoint, TVSeries.from);
}
