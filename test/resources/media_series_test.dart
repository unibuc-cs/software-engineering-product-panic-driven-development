import 'dart:core';
import '../general/resource_test.dart';
import 'package:mediamaster/Models/media_series.dart';
import 'package:mediamaster/Services/series_service.dart';
import 'package:mediamaster/Services/media_series_service.dart';

void main() async {
  Map<String, dynamic> series = {
    'name': 'Assassin\'s creed'
  };
  MediaSeries dummy = MediaSeries(
    mediaId : 1,
    seriesId: await getValidId(
      service: SeriesService.instance,
      backup : series
    ),
    index   : '1.0',
  );

  await runService(
    service  : MediaSeriesService.instance,
    dummyItem: dummy,
    tables   : ['media', 'series'],
  );
}
