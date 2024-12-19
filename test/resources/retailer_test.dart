import 'dart:core';
import '../general/resource_test.dart';
import '../../lib/Models/retailer.dart';
import '../../lib/Services/retailer_service.dart';

void main() async {
  Retailer dummy = Retailer(
    name: 'Fanatical',
  );
  Retailer updated = Retailer(
    name: 'Humble Bundle',
  );

  await runService(
    service    : RetailerService(),
    dummyItem  : dummy,
    updatedItem: updated,
  );
}
