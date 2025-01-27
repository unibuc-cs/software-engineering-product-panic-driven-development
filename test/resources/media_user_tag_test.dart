import 'dart:core';
import '../general/resource_test.dart';
import 'package:mediamaster/Models/media_user_tag.dart';
import 'package:mediamaster/Services/user_tag_service.dart';
import 'package:mediamaster/Services/media_user_tag_service.dart';

void main() async {
  Map<String, dynamic> tag = {
    'name': 'test'
  };
  MediaUserTag dummy = MediaUserTag(
    mediaId: 1,
    userId: '',
    tagId: await getValidId(
      service: UserTagService.instance,
      backup : tag
    ),
  );

  await runService(
    service    : MediaUserTagService.instance,
    dummyItem  : dummy,
    tables     : ['media', 'tag'],
    authNeeded : true,
  );
}
