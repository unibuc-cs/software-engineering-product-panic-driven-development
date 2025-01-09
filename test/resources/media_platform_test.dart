import 'dart:core';
import '../general/resource_test.dart';
import 'package:mediamaster/Models/media_platform.dart';
import 'package:mediamaster/Services/platform_service.dart';
import 'package:mediamaster/Services/media_platform_service.dart';

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
    tables   : ['media', 'platform'],
  );
}
