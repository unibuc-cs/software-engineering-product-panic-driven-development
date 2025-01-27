import 'dart:core';
import '../general/resource_test.dart';
import 'package:mediamaster/Models/media_genre.dart';
import 'package:mediamaster/Services/genre_service.dart';
import 'package:mediamaster/Services/media_genre_service.dart';

void main() async {
  Map<String, dynamic> genre = {
    'name': 'test'
  };
  MediaGenre dummy = MediaGenre(
    mediaId: 1,
    genreId: await getValidId(
      service: GenreService.instance,
      backup : genre
    ),
  );

  await runService(
    service    : MediaGenreService.instance,
    dummyItem  : dummy,
    tables     : ['media', 'genre'],
  );
}
