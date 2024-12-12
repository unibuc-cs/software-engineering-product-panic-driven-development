import 'dart:core';
import 'generic_test.dart';
import '../../lib/Models/media.dart';
import '../../lib/Services/media_service.dart';

void main() async {
  Media dummyMedia = Media(
    originalName: 'Dummy',
    description: 'Description dummy',
    releaseDate: DateTime.now(),
    criticScore: 80,
    communityScore: 93,
    mediaType: 'game',
  );
  Media updatedDummyMedia = Media(
    originalName: 'Updated Dummy',
    description: 'Updated description dummy',
    releaseDate: DateTime.now(),
    criticScore: 84,
    communityScore: 97,
    mediaType: 'book',
  );

  await runService(
    MediaService(),
    dummyMedia,
    updatedDummyMedia,
    (media) => media.toSupa()
  );
}
