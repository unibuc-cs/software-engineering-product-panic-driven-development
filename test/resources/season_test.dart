import 'dart:core';
import '../general/resource_test.dart';
import 'package:mediamaster/Models/season.dart';
import 'package:mediamaster/Services/season_service.dart';
import 'package:mediamaster/Services/tv_series_service.dart';

void main() async {
  Map<String, dynamic> tv_series = {
    'originalname': 'Prison Break',
    'description': 'Due to a political conspiracy, an innocent man is sent to death row and his only hope is his brother, who makes it his mission to deliberately get himself sent to the same prison in order to break the both of them out, from the inside out.',
    'language': 'en',
    'coverimage': '/5E1BhkCgjLBlqx557Z5yzcN0i88.jpg',
    'creators': [
      'Adelstein-Parouse Productions',
      '20th Century Fox Television',
      'RAT Entertainment',
      'Dawn Olmstead Productions',
      'Adelstein Productions',
      'One Light Road Productions',
      'Original Film'
    ],
    'status': 'Ended',
    'communityscore': 81,
    'releasedate': '2005-08-29'
  };

  Season dummy = Season(
    TVSeriesId: await getValidId(
      service: TVSeriesService.instance,
      backup : tv_series,
    ),
    name: 'season 1',
  );
  Season updated = Season(
    TVSeriesId: await getValidId(
      service: TVSeriesService.instance,
      backup : tv_series,
    ),
    name: 'season 2',
  );

  await runService(
    service    : SeasonService.instance,
    dummyItem  : dummy,
    updatedItem: updated,
  );
}
