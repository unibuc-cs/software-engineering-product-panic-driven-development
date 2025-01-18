import 'dart:core';
import '../general/resource_test.dart';
import 'package:mediamaster/Models/note.dart';
import 'package:mediamaster/Models/media.dart';
import 'package:mediamaster/Models/media_user.dart';
import 'package:mediamaster/Services/auth_service.dart';
import 'package:mediamaster/Services/note_service.dart';
import 'package:mediamaster/Services/media_service.dart';
import 'package:mediamaster/Services/media_user_service.dart';

void main() async {
  await login(AuthService.instance);

  Media m = Media(
    originalName: 'Dummy',
    description: 'Description dummy',
    releaseDate: DateTime.now(),
    criticScore: 80,
    communityScore: 93,
    mediaType: 'game',
  );
  await MediaService.instance.create(m);

  MediaUser mu = MediaUser(
    mediaId: 1,
    userId: '',
    name: 'test',
    addedDate: DateTime.now(),
    lastInteracted: DateTime.now(),
  );
  await MediaUserService.instance.create(mu);
  
  Note dummy = Note(
    mediaId: 1,
    userId: '',
    content: 'test',
    creationDate: DateTime.now(),
    modifiedDate: DateTime.now(),
  );

  Note updatedDummy = Note(
    mediaId: 2,
    userId: '',
    content: 'test1234',
    creationDate: DateTime.now(),
    modifiedDate: DateTime.now(),
  );

  await runService(
    service    : NoteService.instance,
    dummyItem  : dummy,
    updatedItem: updatedDummy,
  );

  await MediaUserService.instance.delete(mu.mediaId);
  AuthService.instance.logout();
  print('Logged out');
}
