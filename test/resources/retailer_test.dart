import 'dart:core';
import '../general/resource_test.dart';
import 'package:mediamaster/Models/retailer.dart';
import 'package:mediamaster/Services/retailer_service.dart';

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
    itemName   : dummy.name,
  );
}
