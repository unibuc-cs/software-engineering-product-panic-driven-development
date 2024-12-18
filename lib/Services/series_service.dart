import 'general/request.dart';
import 'general/service.dart';
import '../Models/series.dart';

class SeriesService extends Service<Series> {
  SeriesService()
      : super(
          resource: 'series',
          fromJson: (json) => Series.from(json),
          toJson  : (series) => series.toSupa(),
        );
  
  Future<Series> readByName(String name) async {
    return await request<Series>(
      method: 'GET',
      endpoint: '/series/name?query=$name',
      fromJson: fromJson,
    );
  }
}
