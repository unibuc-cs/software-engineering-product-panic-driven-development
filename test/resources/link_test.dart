import 'dart:core';
import 'generic_test.dart';
import '../../lib/Models/link.dart';
import '../../lib/Services/link_service.dart';

void main() async {
  Link dummyLink = Link(
    name: 'Dummy',
    href: 'https://dummy.com',
  );
  Link updatedDummyLink = Link(
    name: 'Updated Dummy',
    href: 'https://updated-dummy.com',
  );

  await runService(
    LinkService(),
    dummyLink,
    updatedDummyLink,
    (link) => link.toSupa()
  );
}
