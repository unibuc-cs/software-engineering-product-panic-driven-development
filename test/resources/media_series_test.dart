import 'dart:core';
import 'generic_many_to_many_test.dart';
import '../../lib/Models/media_series.dart';
import '../../lib/Services/media_series_service.dart';

void main() async {
  MediaSeries dummyMediaSeries = MediaSeries(
    mediaId: 1,
    seriesId: 2,
    index: 1,
  );
  MediaSeries updatedDummyMediaSeries = MediaSeries(
    mediaId: 2,
    seriesId: 4,
    index: 3,
  );

  await runService(
    MediaSeriesService(),
    dummyMediaSeries,
    updatedDummyMediaSeries,
    "media",
    "series",
    (mediaSeries) => mediaSeries.toSupa()
  );
}
