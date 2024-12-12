import 'dart:core';
import 'generic_test.dart';
import '../../lib/Models/platform.dart';
import '../../lib/Services/platform_service.dart';

void main() async {
  Platform dummyPlatform = Platform(
    name: 'Steam',
  );
  Platform updatedDummyPlatform = Platform(
    name: 'Epic Games',
  );

  await runService(
    PlatformService(),
    dummyPlatform,
    updatedDummyPlatform,
    (platform) => platform.toSupa()
  );
}
