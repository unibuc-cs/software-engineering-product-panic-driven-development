import 'dart:core';
import 'generic_test.dart';
import '../../lib/Models/publisher.dart';
import '../../lib/Services/publisher_service.dart';

void main() async {
  Publisher dummyPublisher = Publisher(
    name: 'Team Cherry',
  );
  Publisher updatedDummyPublisher = Publisher(
    name: 'Team Pear',
  );

  await runService(
    PublisherService(),
    dummyPublisher,
    updatedDummyPublisher,
    (publisher) => publisher.toSupa()
  );

  try {
    final data = await PublisherService().readByName("Team");
    print('Got ${data.toSupa()} by name');
  }
  catch (e) {
    print('GetByName error: $e');
  }
}
