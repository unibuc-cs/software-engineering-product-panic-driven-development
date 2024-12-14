import 'dart:core';
import 'generic_many_to_many_test.dart';
import '../../lib/Models/media_publisher.dart';
import '../../lib/Services/media_publisher_service.dart';

void main() async {
  MediaPublisher dummyMediaPublisher = MediaPublisher(
    mediaId: 4,
    publisherId: 3,
  );
  MediaPublisher updatedDummyMediaPublisher = MediaPublisher(
    mediaId: 4,
    publisherId: 8,
  );

  await runService(
    MediaPublisherService(),
    dummyMediaPublisher,
    updatedDummyMediaPublisher,
    "media",
    "publisher",
    (mediaPublisher) => mediaPublisher.toSupa()
  );
}
