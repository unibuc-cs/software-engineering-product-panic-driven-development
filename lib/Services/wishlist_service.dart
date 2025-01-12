import 'general/service.dart';
import '../Models/wishlist.dart';

class WishlistService extends Service<Wishlist> {
  WishlistService._() : super(Wishlist.endpoint, Wishlist.from);
  
  static final WishlistService _instance = WishlistService._();

  static WishlistService get instance => _instance;
}
