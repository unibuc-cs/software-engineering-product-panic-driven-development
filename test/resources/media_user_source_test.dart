import 'dart:core';
import '../general/resource_test.dart';
import 'package:mediamaster/Models/media_user_source.dart';
import 'package:mediamaster/Services/source_service.dart';
import 'package:mediamaster/Services/media_user_source_service.dart';

void main() async {
  Map<String, dynamic> source = {
    'name'     : 'test',
    'mediatype': 'all',
  };
  MediaUserSource dummy = MediaUserSource(
    mediaId: 1,
    userId: '',
    sourceId: await getValidId(
      service: SourceService.instance,
      backup : source
    ),
  );

  await runService(
    service    : MediaUserSourceService.instance,
    dummyItem  : dummy,
    tables     : ['media', 'source'],
    authNeeded : true,
  );
}
