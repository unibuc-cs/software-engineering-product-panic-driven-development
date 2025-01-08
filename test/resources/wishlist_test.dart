import 'dart:core';
import '../general/resource_test.dart';
import 'package:mediamaster/Models/wishlist.dart';
import 'package:mediamaster/Services/wishlist_service.dart';

void main() async {
  Wishlist dummy = Wishlist(
    mediaId: 1,
    userId: '',
    name: 'test',
    addedDate: DateTime.now(),
    lastInteracted: DateTime.now(),
  );

  Wishlist updatedDummy = Wishlist(
    mediaId: 1,
    userId: '',
    name: 'test1234',
    status: 'test',
    addedDate: DateTime.now(),
    lastInteracted: DateTime.now(),
  );

  await runService(
    service    : WishlistService(),
    dummyItem  : dummy,
    updatedItem: updatedDummy,
    tables     : ['media', 'user'],
    authNeeded : true,
  );
}
