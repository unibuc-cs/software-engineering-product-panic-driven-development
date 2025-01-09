import 'general/service.dart';
import '../Models/wishlist.dart';

class WishlistService extends Service<Wishlist> {
  WishlistService() : super(Wishlist.endpoint, Wishlist.from);
}
