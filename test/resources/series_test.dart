import 'dart:core';
import '../general/resource_test.dart';
import 'package:mediamaster/Models/series.dart';
import 'package:mediamaster/Services/series_service.dart';

void main() async {
  Series dummy = Series(
    name: 'Harry Potter',
  );
  Series updated = Series(
    name: 'Mistborn',
  );

  await runService(
    service    : SeriesService.instance,
    dummyItem  : dummy,
    updatedItem: updated,
    itemName   : dummy.name,
  );
}
