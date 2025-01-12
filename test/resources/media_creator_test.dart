import 'dart:core';
import '../general/resource_test.dart';
import 'package:mediamaster/Models/media_creator.dart';
import 'package:mediamaster/Services/creator_service.dart';
import 'package:mediamaster/Services/media_creator_service.dart';

void main() async {
  Map<String, dynamic> creator = {
    'name': 'From Software',
  };
  MediaCreator dummy = MediaCreator(
    mediaId  : 1,
    creatorId: await getValidId(
      service: CreatorService.instance,
      backup : creator,
    ),
  );

  await runService(
    service   : MediaCreatorService.instance,
    dummyItem : dummy,
    tables    : ['media', 'creator'],
  );
}
