import 'dart:core';
import '../general/resource_test.dart';
import '../../lib/Models/platform.dart';
import '../../lib/Services/platform_service.dart';

void main() async {
  Platform dummy = Platform(
    name: 'XBOX X',
  );
  Platform updated = Platform(
    name: 'PS5',
  );

  await runService(
    service    : PlatformService(),
    dummyItem  : dummy,
    updatedItem: updated,
    itemName   : dummy.name,
  );
}
