import 'Helpers/database.dart';
import 'Models/anime.dart';
import 'Models/book.dart';
import 'Models/manga.dart';
import 'Models/movie.dart';
import 'Models/tv_series.dart';
import 'Services/anime_service.dart';
import 'Services/auth_service.dart';
import 'Services/book_service.dart';
import 'Services/game_service.dart';
import 'Services/manga_service.dart';
import 'Services/media_user_service.dart';
import 'Services/movie_service.dart';
import 'Services/tv_series_service.dart';
import 'Services/wishlist_service.dart';

import 'Models/general/media_type.dart';
import 'Models/game.dart';

class UserSystem {
  // The following 3 definitions are used to make this class a singleton
  UserSystem._();
  
  static final UserSystem _instance = UserSystem._();

  static UserSystem get instance => _instance;
  // Until now we made the class a singleton. Next is what really matters

  Map<String, dynamic>? currentUserData;
  // late final authService;

  void init() {
    // authService = AuthService.instance;
  }

  Future<void> login() async {
    Map<String, dynamic> userData = await AuthService.instance.details();

    while (userData.isEmpty) {
      userData = await AuthService.instance.details();
    }

    currentUserData = Map<String, dynamic>();
    currentUserData!['id'] = userData['id'];
    currentUserData!['name'] = userData['user_metadata']?['name'];
    await HydrateWithUser();
  }

  Future<void> logout() async {
    await AuthService.instance.logout();
    currentUserData = null;
    UnhydrateWithUser();
  }

  String getCurrentUserId() {
    if (currentUserData != null) {
      return currentUserData!['id'];
    }
    return '';
  }

  List<MediaType> getUserMedia(Type type) {
    if (currentUserData == null) {
      return [];
    }

    dynamic userId = currentUserData!['id'];

    var ids = MediaUserService
      .instance
      .items
      .where((mu) => mu.userId == userId)
      .map((mu) => mu.mediaId)
      .toSet();

    dynamic service;

    if (type == Game) {
      service = GameService.instance;
    }
    else if (type == Book) {
      service = BookService.instance;
    }
    else if (type == Anime) {
      service = AnimeService.instance;
    }
    else if (type == Manga) {
      service = MangaService.instance;
    }
    else if (type == Movie) {
      service = MovieService.instance;
    }
    else if (type == TVSeries) {
      service = TVSeriesService.instance;
    }
    else {
      throw UnimplementedError('GetUserMedia of type $type is not implemented!');
    }

    return service
      .items
      .where((mt) => ids.contains(mt.mediaId))
      .toList();
  }
  
  List<MediaType> getWishlist(Type type) {
    if (currentUserData == null) {
      return [];
    }

    dynamic userId = currentUserData!['id'];

    var ids = WishlistService
      .instance
      .items
      .where((wish) => wish.userId == userId)
      .map((wish) => wish.mediaId)
      .toSet();

    dynamic service;

    if (type == Game) {
      service = GameService.instance;
    }
    else if (type == Book) {
      service = BookService.instance;
    }
    else if (type == Anime) {
      service = AnimeService.instance;
    }
    else if (type == Manga) {
      service = MangaService.instance;
    }
    else if (type == Movie) {
      service = MovieService.instance;
    }
    else if (type == TVSeries) {
      service = TVSeriesService.instance;
    }
    else {
      throw UnimplementedError('GetWishlist of type $type is not implemented!');
    }

    return service
      .items
      .where((mt) => ids.contains(mt.mediaId))
      .toList();
  }
}
