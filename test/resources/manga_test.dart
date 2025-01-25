import 'dart:core';
import '../general/resource_test.dart';
import 'package:mediamaster/Models/manga.dart';
import 'package:mediamaster/Services/manga_service.dart';

void main() async {

  final dummy = {
    'id': 49315,
    'originalname': 'Inazuma Eleven',
    'description': 'Raimon Middle School\'s soccer club captain, Endou Mamoru is in a pinch - his club is about to be destroyed! Literally! To avert the wrecking ball and disbanding of the club, his team must win against the toughest soccer team in the area - Teikoku. Will Endou and his team meet a crushing defeat or will a mysterious transfer student with a fiery kick save them from disaster?!',
    'releasedate': '2008-05-15T00:00:00.000',
    // 'genres': [
    //   'Action',
    //   'Comedy',
    //   'Fantasy',
    //   'Sports'
    // ],
    'retailers': [
      'test'
    ],
    // 'coverimage': 'https://s4.anilist.co/file/anilistcdn/media/manga/cover/medium/bx49315-2AqZShRMXyfx.png',
    'communityscore': 69,
    'criticscore': 65,
    'status': 'FINISHED',
    'links': [
      'https://www.shogakukan.co.jp/books/volume/19243',
      'https://twitter.com/inazuma_project'
    ],
    'nrchapters': 42,
    'nrvolumes': 10,
  };
  Manga updated = Manga(
    mediaId: 10,
    language: 'romanian',
    totalPages: 10,
    nrChapters: 124
  );

  await runService(
    service    : MangaService.instance,
    dummyItem  : dummy,
    updatedItem: updated,
  );
}
