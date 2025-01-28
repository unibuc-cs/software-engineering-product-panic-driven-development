import 'dart:core';
import '../general/resource_test.dart';
import 'package:mediamaster/Models/source.dart';
import 'package:mediamaster/Services/source_service.dart';

void main() async {
  Source dummy = Source(
    name: 'Dummy',
    mediaType: 'all',
  );
  Source updated = Source(
    name: 'Updated Dummy',
    mediaType: 'all',
  );

  await runService(
    service    : SourceService.instance,
    dummyItem  : dummy,
    updatedItem: updated,
    itemName   : dummy.name,
  );
}
