import 'dart:core';
import 'generic_test.dart';
import '../../lib/Models/genre.dart';
import '../../lib/Services/genre_service.dart';

void main() async {
  Genre dummyGenre= Genre(
    name: 'Dummy',
  );
  Genre updatedDummyGenre = Genre(
    name: 'Updated Dummy',
  );

  await runService(
    GenreService(),
    dummyGenre,
    updatedDummyGenre,
    (genre) => genre.toSupa()
  );
}
