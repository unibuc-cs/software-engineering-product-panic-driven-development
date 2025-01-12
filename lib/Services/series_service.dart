import 'general/service.dart';
import '../Models/series.dart';

class SeriesService extends Service<Series> {
  SeriesService._() : super(Series.endpoint, Series.from);
  
  static final SeriesService _instance = SeriesService._();

  static SeriesService get instance => _instance;
}
