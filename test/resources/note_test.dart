import 'dart:core';
import '../general/resource_test.dart';
import 'package:mediamaster/Models/note.dart';
import 'package:mediamaster/Services/note_service.dart';

void main() async {
  Note dummy = Note(
    mediaId: 1,
    userId: '',
    content: 'test',
    creationDate: DateTime.now(),
    modifiedDate: DateTime.now(),
  );

  Note updatedDummy = Note(
    mediaId: 1,
    userId: '',
    content: 'test1234',
    creationDate: DateTime.now(),
    modifiedDate: DateTime.now(),
  );

  await runService(
    service    : NoteService(),
    dummyItem  : dummy,
    updatedItem: updatedDummy,
    tables     : ['media'],
    authNeeded : true,
  );
}
