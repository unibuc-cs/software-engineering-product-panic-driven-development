import 'dart:core';
import 'generic_test.dart';
import '../../lib/Models/media_link.dart';
import '../../lib/Services/link_service.dart';
import '../../lib/Services/media_link_service.dart';

void main() async {
  Map<String, dynamic> link = {
    'name': 'example',
    'href': 'http://example.com',
  };
  MediaLink dummy = MediaLink(
    mediaId: 1,
    linkId : await getValidId(
      service: LinkService(),
      backup : link,
    ),
  );

  await runService(
    service  : MediaLinkService(),
    dummyItem: dummy,
    tables   : ["media", "link"],
    toJson   : (mediaLink) => mediaLink.toSupa(),
  );
}
