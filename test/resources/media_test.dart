import 'dart:core';
import '../general/resource_test.dart';
import 'package:mediamaster/Models/media.dart';
import 'package:mediamaster/Services/media_service.dart';

void main() async {
  Media dummy = Media(
    originalName: 'Dummy',
    description: 'Description dummy',
    releaseDate: DateTime.now(),
    criticScore: 80,
    communityScore: 93,
    mediaType: 'game',
  );
  Media updated = Media(
    originalName: 'Updated Dummy',
    description: 'Updated description dummy',
    releaseDate: DateTime.now(),
    criticScore: 84,
    communityScore: 97,
    mediaType: 'book',
  );

  await runService(
    service    : MediaService.instance,
    dummyItem  : dummy,
    updatedItem: updated,
  );
}
