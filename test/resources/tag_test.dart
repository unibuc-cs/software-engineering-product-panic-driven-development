import 'dart:core';
import 'generic_test.dart';
import '../../lib/Models/tag.dart';
import '../../lib/Services/tag_service.dart';

void main() async {
  Tag dummyTag = Tag(
    name: 'Dummy',
  );
  Tag updatedDummyTag = Tag(
    name: 'Updated Dummy',
  );

  await runService(
    TagService(),
    dummyTag,
    updatedDummyTag,
    (tag) => tag.toSupa()
  );
}
