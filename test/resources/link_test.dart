import 'dart:core';
import 'generic_test.dart';
import '../../lib/Models/link.dart';
import '../../lib/Services/link_service.dart';

void main() async {
  Link dummy = Link(
    name: 'Dummy',
    href: 'https://dummy.com',
  );
  Link updated = Link(
    name: 'Updated Dummy',
    href: 'https://updated-dummy.com',
  );

  await runService(
    service    : LinkService(),
    dummyItem  : dummy,
    updatedItem: updated,
    itemName   : dummy.name,
    toJson     : (link) => link.toJson(),
  );
}
