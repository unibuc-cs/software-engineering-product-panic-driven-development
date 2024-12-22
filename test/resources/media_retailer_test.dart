import 'dart:core';
import '../general/resource_test.dart';
import 'package:mediamaster/Models/media_retailer.dart';
import 'package:mediamaster/Services/retailer_service.dart';
import 'package:mediamaster/Services/media_retailer_service.dart';

void main() async {
  Map<String, dynamic> retailer = {
    'name': 'Fanatical'
  };
  MediaRetailer dummy = MediaRetailer(
    mediaId   : 1,
    retailerId: await getValidId(
      service: RetailerService(),
      backup : retailer
    ),
  );

  await runService(
    service  : MediaRetailerService(),
    dummyItem: dummy,
    tables   : ['media', 'retailer'],
  );
}
