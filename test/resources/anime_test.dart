import 'dart:core';
import '../general/resource_test.dart';
import 'package:mediamaster/Models/anime.dart';
import 'package:mediamaster/Services/anime_service.dart';

void main() async {

  final dummy = {
    'id': 5231,
    'originalname': 'Inazuma Eleven',
    'description': 'The main character, Endou Mamoru, is a very talented goalkeeper and the grandson of one of the strongest goalkeepers in Japan, who died before he was born. Even though his skills are incredible his school lacks a real soccer club as the 6 other members don\'t appear very interested even in training. But as soon as a mysterious forward called Gouenji moves to Endou\'s town, the young goalkeeper sets out to find and recruit members for his soccer team. (Source: Wikipedia)',
    'releasedate': '2008-10-05T00:00:00.000',
    'genres': [
      'Sports'
    ],
    'retailers': [
      'test'
    ],
    // 'coverimage': 'https://s4.anilist.co/file/anilistcdn/media/anime/cover/medium/bx5231-LOB6lgM2Coto.png',
    'communityscore': 76,
    'criticscore': 76,
    'status': 'FINISHED',
    'links': [
      'https://www.netflix.com/title/80007757',
      'https://www.primevideo.com/detail/0TN5ICF7AIEHNKWRVEQY2C6VCD',
      'https://www.bilibili.tv/media/36801',
      'https://www.primevideo.com/-/es/detail/0TN5ICF7AIEHNKWRVEQY2C6VCD/ref=atv_dp_share_cu_r'
    ],
    'episodes': 127,
    'duration': 25,
    'language': 'english',
  };
  Anime updated = Anime(
    mediaId: 10,
    language: 'romanian',
  );

  await runService(
    service    : AnimeService(),
    dummyItem  : dummy,
    updatedItem: updated,
  );
}
