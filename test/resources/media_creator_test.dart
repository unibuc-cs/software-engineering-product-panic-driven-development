import 'dart:core';
import 'generic_many_to_many_test.dart';
import '../../lib/Models/media_creator.dart';
import '../../lib/Services/media_creator_service.dart';

void main() async {
  MediaCreator dummyMediaCreator = MediaCreator(
    mediaId: 4,
    creatorId: 6,
  );
  MediaCreator updatedDummyMediaCreator = MediaCreator(
    mediaId: 5,
    creatorId: 7,
  );

  await runService(
    MediaCreatorService(),
    dummyMediaCreator,
    updatedDummyMediaCreator,
    "media",
    "creator",
    (mediaCreator) => mediaCreator.toSupa()
  );
}
