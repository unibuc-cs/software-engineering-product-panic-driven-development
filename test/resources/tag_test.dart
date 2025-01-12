import 'dart:core';
import '../general/resource_test.dart';
import 'package:mediamaster/Models/tag.dart';
import 'package:mediamaster/Services/tag_service.dart';

void main() async {
  Tag dummy = Tag(
    name: 'Dummy',
  );
  Tag updated = Tag(
    name: 'Updated Dummy',
  );

  await runService(
    service    : TagService.instance,
    dummyItem  : dummy,
    updatedItem: updated,
  );
}
