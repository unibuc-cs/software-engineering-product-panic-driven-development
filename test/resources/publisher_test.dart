import 'dart:core';
import '../general/resource_test.dart';
import 'package:mediamaster/Models/publisher.dart';
import 'package:mediamaster/Services/publisher_service.dart';

void main() async {
  Publisher dummy = Publisher(
    name: 'Team Cherry',
  );
  Publisher updated = Publisher(
    name: 'Team Pear',
  );

  await runService(
    service    : PublisherService(),
    dummyItem  : dummy,
    updatedItem: updated,
    itemName   : dummy.name,
  );
}
