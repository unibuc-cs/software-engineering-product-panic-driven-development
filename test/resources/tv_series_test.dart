import 'dart:core';
import '../general/resource_test.dart';
import 'package:mediamaster/Models/tv_series.dart';
import 'package:mediamaster/Services/tv_series_service.dart';

void main() async {

  final dummy = {
    'originalname': 'Prison Break',
    'description': 'Due to a political conspiracy, an innocent man is sent to death row and his only hope is his brother, who makes it his mission to deliberately get himself sent to the same prison in order to break the both of them out, from the inside out.',
    'language': 'en',
    // 'coverimage': '/5E1BhkCgjLBlqx557Z5yzcN0i88.jpg',
    'creators': [
      'Adelstein-Parouse Productions',
      '20th Century Fox Television',
      'RAT Entertainment',
      'Dawn Olmstead Productions',
      'Adelstein Productions',
      'One Light Road Productions',
      'Original Film'
    ],
    'retailers': [
      'test'
    ],
    'status': 'Ended',
    'communityscore': 81,
    'releasedate': '2005-08-29'
  };
  TVSeries updated = TVSeries(
    mediaId: 10,
    language: 'romanian',
  );

  await runService(
    service    : TVSeriesService(),
    dummyItem  : dummy,
    updatedItem: updated,
  );
}
