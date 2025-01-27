import 'dart:core';
import '../general/resource_test.dart';
import 'package:mediamaster/Models/user_tag.dart';
import 'package:mediamaster/Services/user_tag_service.dart';

void main() async {
  UserTag dummy = UserTag(
    userId   : 'someDummyUserId',
    name     : 'Dummy',
    mediaType: 'one of the medias',
  );
  UserTag updated = UserTag(
    userId   : 'someDummyUserId',
    name     : 'Updated Dummy',
    mediaType: 'one of the medias',
  );

  await runService(
    service    : UserTagService.instance,
    dummyItem  : dummy,
    updatedItem: updated,
  );
}
