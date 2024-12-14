import 'dart:core';
import 'generic_many_to_many_test.dart';
import '../../lib/Models/media_retailer.dart';
import '../../lib/Services/media_retailer_service.dart';

void main() async {
  MediaRetailer dummyMediaRetailer = MediaRetailer(
    mediaId: 4,
    retailerId: 2,
  );
  MediaRetailer updatedDummyMediaRetailer = MediaRetailer(
    mediaId: 5,
    retailerId: 4,
  );

  await runService(
    MediaRetailerService(),
    dummyMediaRetailer,
    updatedDummyMediaRetailer,
    "media",
    "retailer",
    (mediaRetailer) => mediaRetailer.toSupa()
  );
}
