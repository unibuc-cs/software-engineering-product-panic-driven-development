import 'dart:core';
import '../general/resource_test.dart';
import 'package:mediamaster/Models/media_link.dart';
import 'package:mediamaster/Services/link_service.dart';
import 'package:mediamaster/Services/media_link_service.dart';

void main() async {
  Map<String, dynamic> link = {
    'name': 'example',
    'href': 'http://example.com',
  };
  MediaLink dummy = MediaLink(
    mediaId: 1,
    linkId : await getValidId(
      service: LinkService.instance,
      backup : link,
    ),
  );

  await runService(
    service  : MediaLinkService.instance,
    dummyItem: dummy,
    tables   : ['media', 'link'],
  );
}
