import 'dart:core';
import 'generic_test.dart';
import '../../lib/Models/tag.dart';
import '../../lib/Services/tag_service.dart';

void main() async {
  Tag dummy = Tag(
    name: 'Dummy',
  );
  Tag updated = Tag(
    name: 'Updated Dummy',
  );

  await runService(
    service    : TagService(),
    dummyItem  : dummy,
    updatedItem: updated,
    toJson     : (tag) => tag.toJson(),
  );
}
