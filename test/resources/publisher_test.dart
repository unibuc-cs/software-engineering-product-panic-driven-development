import 'dart:core';
import 'generic_test.dart';
import '../../lib/Models/publisher.dart';
import '../../lib/Services/publisher_service.dart';

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
    itemName   : "Team",
    toJson     : (publisher) => publisher.toSupa(),
  );
}
