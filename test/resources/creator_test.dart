import 'dart:core';
import 'generic_test.dart';
import '../../lib/Models/creator.dart';
import '../../lib/Services/creator_service.dart';

void main() async {
  Creator dummy = Creator(
    name: 'Team Cherry',
  );
  Creator updated = Creator(
    name: 'Team Apple',
  );

  await runService(
    service    : CreatorService(),
    dummyItem  : dummy,
    updatedItem: updated,
    itemName   : dummy.name,
    toJson     : (creator) => creator.toJson(),
  );
}
