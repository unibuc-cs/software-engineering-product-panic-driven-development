import 'dart:core';
import '../general/resource_test.dart';
import 'package:mediamaster/Models/game.dart';
import 'package:mediamaster/Services/game_service.dart';

void main() async {
  final dummy = {
    'genres': [
      'Platform',
      'Adventure',
      'Indie'
    ],
    'platforms': [
      'PC (Microsoft Windows)',
      'Wii U',
      'Linux',
      'Mac',
      'Nintendo Switch'
    ],
    'url': 'https://www.igdb.com/games/hollow-knight',
    'originalname': 'Hollow Knight (2017)',
    'releasedate': '2017-02-24T00:00:00.000',
    'description': 'A 2D metroidvania with an emphasis on close combat and exploration in which the player enters the once-prosperous now-bleak insect kingdom of Hallownest, travels through its various districts, meets friendly inhabitants, fights hostile ones and uncovers the kingdom\'s history while improving their combat abilities and movement arsenal by fighting bosses and accessing out-of-the-way areas.',
    'criticscore': 91,
    // 'coverimage': '//images.igdb.com/igdb/image/upload/t_original/co93cr.jpg',
    'seriesname': [
      'Hollow Knight'
    ],
    'creators': [
      'Team Cherry'
    ],
    'publishers': [
      'Team Cherry'
    ],
    'retailers': [
      'test'
    ],
    'communityscore': 92,
    'links': [
      'https://en.wikipedia.org/wiki/Hollow_Knight',
      'https://www.gog.com/game/hollow_knight',
      'https://store.steampowered.com/app/367520',
      'https://www.reddit.com/r/HollowKnight',
      'http://hollowknight.com/',
      'https://www.facebook.com/HollowKnightGame',
      'https://www.twitch.tv/directory/game/Hollow%20Knight',
      'https://twitter.com/teamcherrygames',
      'https://hollowknight.wiki/w/Hollow_Knight_(game)',
      'https://www.youtube.com/@TeamCherry'
    ]
  };
  Game updated = Game(
    mediaId: 10,
    HDDMinimum: 'test',
  );

  await runService(
    service    : GameService.instance,
    dummyItem  : dummy,
    updatedItem: updated,
  );
}
