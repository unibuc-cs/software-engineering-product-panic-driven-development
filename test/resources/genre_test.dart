import 'dart:core';
import '../../lib/Models/genre.dart';
import '../general/resource_test.dart';
import '../../lib/Services/genre_service.dart';

void main() async {
  Genre dummy = Genre(
    name: 'Dummy',
  );
  Genre updated = Genre(
    name: 'Updated Dummy',
  );

  await runService(
    service    : GenreService(),
    dummyItem  : dummy,
    updatedItem: updated,
  );
}
