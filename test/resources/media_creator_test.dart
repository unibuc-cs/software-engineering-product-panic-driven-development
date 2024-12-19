import 'dart:core';
import '../general/resource_test.dart';
import '../../lib/Models/media_creator.dart';
import '../../lib/Services/creator_service.dart';
import '../../lib/Services/media_creator_service.dart';

void main() async {
  Map<String, dynamic> creator = {
    'name': 'From Software',
  };
  MediaCreator dummy = MediaCreator(
    mediaId  : 1,
    creatorId: await getValidId(
      service: CreatorService(),
      backup : creator,
    ),
  );

  await runService(
    service   : MediaCreatorService(),
    dummyItem : dummy,
    tables    : ["media", "creator"],
  );
}
