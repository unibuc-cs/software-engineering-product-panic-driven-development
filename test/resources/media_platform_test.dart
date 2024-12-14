import 'dart:core';
import 'generic_many_to_many_test.dart';
import '../../lib/Models/media_platform.dart';
import '../../lib/Services/media_platform_service.dart';

void main() async {
  MediaPlatform dummyMediaPlatform = MediaPlatform(
    mediaId: 6,
    platformId: 1,
  );
  MediaPlatform updatedDummyMediaPlatform = MediaPlatform(
    mediaId: 7,
    platformId: 3,
  );

  await runService(
    MediaPlatformService(),
    dummyMediaPlatform,
    updatedDummyMediaPlatform,
    "media",
    "platform",
    (mediaPlatform) => mediaPlatform.toSupa()
  );
}
