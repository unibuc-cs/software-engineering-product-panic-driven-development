import 'dart:core';
import '../general/resource_test.dart';
import 'package:mediamaster/Models/media_publisher.dart';
import 'package:mediamaster/Services/publisher_service.dart';
import 'package:mediamaster/Services/media_publisher_service.dart';

void main() async {
  Map<String, dynamic> publisher = {
    'name': 'Team17',
  };
  MediaPublisher dummy = MediaPublisher(
    mediaId    : 1,
    publisherId: await getValidId(
      service: PublisherService.instance,
      backup : publisher,
    ),
  );

  await runService(
    service  : MediaPublisherService.instance,
    dummyItem: dummy,
    tables   : ['media', 'publisher'],
  );
}
