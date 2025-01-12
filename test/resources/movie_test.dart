import 'dart:core';
import '../general/resource_test.dart';
import 'package:mediamaster/Models/movie.dart';
import 'package:mediamaster/Services/movie_service.dart';

void main() async {

  final dummy = {
    'originalname': 'Home Alone',
    'description': 'Eight-year-old Kevin McCallister makes the most of the situation after his family unwittingly leaves him behind when they go on Christmas vacation. When thieves try to break into his home, he puts up a fight like no other.',
    'language': 'en',
    // 'coverimage': '/onTSipZ8R3bliBdKfPtsDuHTdlL.jpg',
    'creators': [
      'Hughes Entertainment',
      '20th Century Fox'
    ],
    'status': 'Released',
    'communityscore': 74,
    'seriesname': [
      'Home Alone Collection'
    ],
    'retailers': [
      'test'
    ],
    'releasedate': '1990-11-16',
    'durationinseconds': 6180
  };
  Movie updated = Movie(
    mediaId: 10,
    language: 'english',
    durationInSeconds: 620,
  );

  await runService(
    service    : MovieService.instance,
    dummyItem  : dummy,
    updatedItem: updated,
  );
}
