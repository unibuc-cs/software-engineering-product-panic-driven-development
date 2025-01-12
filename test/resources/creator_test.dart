import 'dart:core';
import '../general/resource_test.dart';
import 'package:mediamaster/Models/creator.dart';
import 'package:mediamaster/Services/creator_service.dart';

void main() async {
  Creator dummy = Creator(
    name: 'Team Cherry',
  );
  Creator updated = Creator(
    name: 'Team Apple',
  );

  await runService(
    service    : CreatorService.instance,
    dummyItem  : dummy,
    updatedItem: updated,
    itemName   : dummy.name,
  );
}
