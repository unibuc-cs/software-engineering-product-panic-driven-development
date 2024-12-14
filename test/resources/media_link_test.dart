import 'dart:core';
import 'generic_many_to_many_test.dart';
import '../../lib/Models/media_link.dart';
import '../../lib/Services/media_link_service.dart';

void main() async {
  MediaLink dummyMediaLink = MediaLink(
    mediaId: 7,
    linkId: 5,
  );
  MediaLink updatedDummyMediaLink = MediaLink(
    mediaId: 8,
    linkId: 10,
  );

  await runService(
    MediaLinkService(),
    dummyMediaLink,
    updatedDummyMediaLink,
    "media",
    "link",
    (mediaLink) => mediaLink.toSupa()
  );
}
