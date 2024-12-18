import 'dart:core';
import 'generic_test.dart';
import '../../lib/Models/genre.dart';
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
    toJson     : (genre) => genre.toSupa(),
  );
}
