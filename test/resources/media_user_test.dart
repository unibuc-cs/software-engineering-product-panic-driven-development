import 'dart:core';
import '../general/resource_test.dart';
import 'package:mediamaster/Models/media_user.dart';
import 'package:mediamaster/Services/media_user_service.dart';

void main() async {
  MediaUser dummy = MediaUser(
    mediaId: 1,
    userId: '',
    name: 'test',
    addedDate: DateTime.now(),
    lastInteracted: DateTime.now(),
  );

  MediaUser updatedDummy = MediaUser(
    mediaId: 1,
    userId: '',
    name: 'test1234',
    status: 'test',
    addedDate: DateTime.now(),
    lastInteracted: DateTime.now(),
  );

  await runService(
    service    : MediaUserService.instance,
    dummyItem  : dummy,
    updatedItem: updatedDummy,
    tables     : ['media'],
    authNeeded : true,
  );
}
