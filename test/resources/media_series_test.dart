import 'dart:core';
import 'generic_test.dart';
import '../../lib/Models/media_series.dart';
import '../../lib/Services/series_service.dart';
import '../../lib/Services/media_series_service.dart';

void main() async {
  Map<String, dynamic> series = {
    'name': 'Harry Potter'
  };
  MediaSeries dummy = MediaSeries(
    mediaId : 1,
    seriesId: await getValidId(
      service: SeriesService(),
      backup : series
    ),
    index   : 1,
  );

  await runService(
    service  : MediaSeriesService(),
    dummyItem: dummy,
    tables   : ["media", "series"],
    toJson   : (mediaSeries) => mediaSeries.toSupa(),
  );
}
