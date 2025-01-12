import 'dart:core';
import '../general/resource_test.dart';
import 'package:mediamaster/Models/media_user_genre.dart';
import 'package:mediamaster/Services/genre_service.dart';
import 'package:mediamaster/Services/media_user_genre_service.dart';

void main() async {
  Map<String, dynamic> genre = {
    'name': 'test'
  };
  MediaUserGenre dummy = MediaUserGenre(
    mediaId: 1,
    userId: '',
    genreId: await getValidId(
      service: GenreService.instance,
      backup : genre
    ),
  );

  await runService(
    service    : MediaUserGenreService.instance,
    dummyItem  : dummy,
    tables     : ['media', 'genre'],
    authNeeded : true,
  );
}
