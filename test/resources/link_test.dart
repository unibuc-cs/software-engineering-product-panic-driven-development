import 'dart:core';
import '../general/resource_test.dart';
import 'package:mediamaster/Models/link.dart';
import 'package:mediamaster/Services/link_service.dart';

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
    itemName   : dummy.href,
  );
}
