import 'dart:core';
import 'generic_test.dart';
import '../../lib/Models/creator.dart';
import '../../lib/Services/creator_service.dart';

void main() async {
  Creator dummyCreator = Creator(
    name: 'Team Cherry',
  );
  Creator updatedDummyCreator = Creator(
    name: 'Team Apple',
  );

  await runService(
    CreatorService(),
    dummyCreator,
    updatedDummyCreator,
    (creator) => creator.toSupa()
  );

  try {
    final data = await CreatorService().readByName("Team Cherry");
    print('Got ${data.toSupa()} by name');
  }
  catch (e) {
    print('GetByName error: $e');
  }
}
