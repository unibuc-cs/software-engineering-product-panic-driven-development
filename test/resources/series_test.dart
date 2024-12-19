import 'dart:core';
import 'generic_test.dart';
import '../../lib/Models/series.dart';
import '../../lib/Services/series_service.dart';

void main() async {
  Series dummy = Series(
    name: 'Harry Potter',
  );
  Series updated = Series(
    name: 'Mistborn',
  );

  await runService(
    service    : SeriesService(),
    dummyItem  : dummy,
    updatedItem: updated,
    itemName   : dummy.name,
    toJson     : (series) => series.toJson(),
  );
}
