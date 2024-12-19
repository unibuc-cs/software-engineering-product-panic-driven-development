import 'dart:core';
import 'generic_test.dart';
import '../../lib/Models/media_publisher.dart';
import '../../lib/Services/publisher_service.dart';
import '../../lib/Services/media_publisher_service.dart';

void main() async {
  Map<String, dynamic> publisher = {
    'name': 'Team17',
  };
  MediaPublisher dummy = MediaPublisher(
    mediaId    : 1,
    publisherId: await getValidId(
      service: PublisherService(),
      backup : publisher,
    ),
  );

  await runService(
    service  : MediaPublisherService(),
    dummyItem: dummy,
    tables   : ["media", "publisher"],
    toJson   : (mediaPlatform) => mediaPlatform.toJson(),
  );
}
