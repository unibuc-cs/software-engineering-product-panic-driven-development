import 'dart:core';
import '../general/resource_test.dart';
import 'package:mediamaster/Models/platform.dart';
import 'package:mediamaster/Services/platform_service.dart';

void main() async {
  Platform dummy = Platform(
    name: 'XBOX X',
  );
  Platform updated = Platform(
    name: 'PS5',
  );

  await runService(
    service    : PlatformService.instance,
    dummyItem  : dummy,
    updatedItem: updated,
    itemName   : dummy.name,
  );
}
