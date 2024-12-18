import 'dart:core';
import 'generic_test.dart';
import '../../lib/Models/series.dart';
import '../../lib/Services/series_service.dart';

void main() async {
  Series dummySeries = Series(
    name: 'Harry Potter',
  );
  Series updatedDummySeries = Series(
    name: 'Mistborn',
  );

  await runService(
    SeriesService(),
    dummySeries,
    updatedDummySeries,
    (series) => series.toSupa()
  );

  try {
    final data = await SeriesService().readByName("Red rising");
    print('Got ${data.toSupa()} by name');
  }
  catch (e) {
    print('GetByName error: $e');
  }
}
