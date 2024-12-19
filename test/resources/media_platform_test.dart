import 'dart:core';
import 'generic_test.dart';
import '../../lib/Models/media_platform.dart';
import '../../lib/Services/platform_service.dart';
import '../../lib/Services/media_platform_service.dart';

void main() async {
  Map<String, dynamic> platform = {
    'name': 'PC',
  };
  MediaPlatform dummy = MediaPlatform(
    mediaId   : 1,
    platformId: await getValidId(
      service: PlatformService(),
      backup : platform,
    ),
  );

  await runService(
    service  : MediaPlatformService(),
    dummyItem: dummy,
    tables   : ["media", "platform"],
    toJson   : (mediaPlatform) => mediaPlatform.toJson(),
  );
}
