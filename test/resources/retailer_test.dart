import 'dart:core';
import 'generic_test.dart';
import '../../lib/Models/retailer.dart';
import '../../lib/Services/retailer_service.dart';

void main() async {
  Retailer dummyRetailer = Retailer(
    name: 'Fanatical',
  );
  Retailer updatedDummyRetailer = Retailer(
    name: 'Humble Bundle',
  );

  await runService(
    RetailerService(),
    dummyRetailer,
    updatedDummyRetailer,
    (retailer) => retailer.toSupa()
  );
}
