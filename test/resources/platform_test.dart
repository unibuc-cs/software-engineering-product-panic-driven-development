import 'dart:core';
import 'generic_test.dart';
import '../../lib/Models/platform.dart';
import '../../lib/Services/platform_service.dart';

void main() async {
  Platform dummyPlatform = Platform(
    name: 'XBOX X',
  );
  Platform updatedDummyPlatform = Platform(
    name: 'PS5',
  );

  await runService(
    PlatformService(),
    dummyPlatform,
    updatedDummyPlatform,
    (platform) => platform.toSupa()
  );

  try {
    final data = await PlatformService().readByName("PS4");
    print('Got ${data.toSupa()} by name');
  }
  catch (e) {
    print('GetByName error: $e');
  }
}
