import 'dart:core';
import '../general/resource_test.dart';
import 'package:mediamaster/Models/genre.dart';
import 'package:mediamaster/Services/genre_service.dart';

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
    authNeeded : true,
  );
}
